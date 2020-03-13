import os.path
import subprocess
import yaml


TEMPLATES = [
    "charts/namespace.yaml",
    "charts/prometheus",
    "charts/loki",
    "charts/grafana",
    "promtail",
]

HELM_REPOS = {
    "stable": "https://kubernetes-charts.storage.googleapis.com",
    "loki": "https://grafana.github.io/loki/charts",
}

LOOSE_RESOURCES = [
    "namespace.yaml",
    "configuration",
    "storage",
]

HELM_CHARTS = {
    "prometheus": "stable/prometheus",
    "loki": "loki/loki",
    "grafana": "stable/grafana",
}


def _create_dashboard_configmap(output_dir, namespace):
    dashboard_path = os.path.abspath("./dashboards")
    command = (
        "kubectl create configmap grafana-dashboards -o yaml "
        "--from-file=%s --dry-run=true --namespace=%s "
        "> %s/configuration/dashboards.cm.yaml"
    ) % (dashboard_path, namespace, output_dir)
    try:
        subprocess.check_output(command, shell=True)
    except subprocess.CalledProcessError as err:
        print(err.output)


def _run_ytt(config, output_dir):
    config_string = "#@data/values\n---\n"
    config_string += yaml.dump(config)

    command = [
        "ytt",
    ]

    for template in TEMPLATES:
        command += ["-f", template]

    command += [
        "--output-directory",
        output_dir,
        "--ignore-unknown-comments",
        "-f",
        "-",
    ]

    try:
        # pylint: disable=E1123
        print(subprocess.check_output(command, input=config_string, text=True))
    except subprocess.CalledProcessError as err:
        print(err.output)


def _update_helm_repos():
    for repo, url in HELM_REPOS.items():
        command = ["helm", "repo", "add", repo, url]
        try:
            subprocess.check_output(" ".join(command), shell=True)
        except subprocess.CalledProcessError as err:
            print(err.output)
    try:
        print(subprocess.check_output(["helm", "repo", "update"]).decode("utf-8"))
    except subprocess.CalledProcessError as err:
        print(err.output)


def _deploy_loose_resources(output_dir):
    for resource in LOOSE_RESOURCES:
        command = [
            "kubectl",
            "apply",
            "-f",
            "%s/%s" % (output_dir, resource),
        ]
        print(subprocess.check_output(command).decode("utf-8"))


def _get_installed_charts_in_namespace(namespace):
    command = ["helm", "ls", "-n", namespace, "--short"]
    return subprocess.check_output(command).decode("utf-8").split("\n")


def _install_or_update_charts(output_dir, namespace):
    installed_charts = _get_installed_charts_in_namespace(namespace)
    charts_path = os.path.abspath("./charts")
    for chart, repo in HELM_CHARTS.items():
        chart_name = chart + "-" + namespace
        with open("%s/%s/VERSION" % (charts_path, chart), "r") as f:
            chart_version = f.readlines()[0].strip()
        command = ["helm"]
        command.append("upgrade" if chart_name in installed_charts else "install")
        command += [
            chart_name,
            repo,
            "--version",
            chart_version,
            "--values",
            "%s/%s.yaml" % (output_dir, chart),
            "--namespace",
            namespace,
        ]
        try:
            print(subprocess.check_output(command).decode("utf-8"))
        except subprocess.CalledProcessError as err:
            print(err.output)


def install(config_manager, output_dir, dryrun, update_repo):
    """Creates the final configuration for the helm charts and Kubernetes resources
    and installs them to Kubernetes, if not run in --dryrun mode.

    Arguments:
        config_manager {AbstractConfigManager} -- ConfigManager that contains the
          configuration of the monitoring setup to be uninstalled.
        output_dir {string} -- Path to the directory where the generated files
          should be safed in
        dryrun {boolean} -- Whether the installation will be run in dryrun mode
        update_repo {boolean} -- Whether to update the helm repositories locally
    """
    _run_ytt(config_manager.get_config(), output_dir)

    namespace = config_manager.get_config()["namespace"]
    _create_dashboard_configmap(output_dir, namespace)

    if not dryrun:
        if update_repo:
            _update_helm_repos()
        _deploy_loose_resources(output_dir)
        _install_or_update_charts(output_dir, namespace)
