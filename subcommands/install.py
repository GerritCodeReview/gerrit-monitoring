# Copyright (C) 2020 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import os.path
import stat
import subprocess
import zipfile

import requests
import yaml

from ._globals import HELM_CHARTS


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
    "dashboards",
    "storage",
]


def _create_dashboard_configmaps(output_dir, namespace):
    dashboards_dir = os.path.abspath("./dashboards")

    output_dir = os.path.join(output_dir, "dashboards")
    if not os.path.exists(output_dir):
        os.mkdir(output_dir)

    for dashboard in os.listdir(dashboards_dir):
        dashboard_path = os.path.join(dashboards_dir, dashboard)
        dashboard_name = os.path.splitext(dashboard)[0]
        output_file = f"{output_dir}/{dashboard_name}.dashboard.yaml"
        command = (
            f"kubectl create configmap {dashboard_name} -o yaml "
            f"--from-file={dashboard_path} --dry-run=client --namespace={namespace} "
            f"> {output_file}"
        )

        try:
            subprocess.check_output(command, shell=True)
        except subprocess.CalledProcessError as err:
            print(err.output)

        with open(output_file, "r") as f:
            dashboard_cm = yaml.load(f, Loader=yaml.SafeLoader)
            dashboard_cm["metadata"]["labels"] = dict()
            dashboard_cm["metadata"]["labels"]["grafana_dashboard"] = dashboard_name

        with open(output_file, "w") as f:
            yaml.dump(dashboard_cm, f)


def _create_promtail_configs(config, output_dir):
    if not os.path.exists(os.path.join(output_dir, "promtail")):
        os.mkdir(os.path.join(output_dir, "promtail"))

    with open(os.path.join(output_dir, "promtail.yaml")) as f:
        for promtail_config in yaml.load_all(f, Loader=yaml.SafeLoader):
            with open(
                os.path.join(
                    output_dir,
                    "promtail",
                    "promtail-%s"
                    % promtail_config["scrape_configs"][0]["static_configs"][0][
                        "labels"
                    ]["host"],
                ),
                "w",
            ) as f:
                yaml.dump(promtail_config, f)

    os.remove(os.path.join(output_dir, "promtail.yaml"))

    if not config["tls"]["skipVerify"]:
        try:
            with open(
                os.path.join(output_dir, "promtail", "promtail.ca.crt"), "w"
            ) as f:
                f.write(config["tls"]["caCert"])
        except TypeError:
            print("CA certificate for TLS verification has to be given.")


def _download_promtail(output_dir):
    with open(os.path.abspath("./promtail/VERSION"), "r") as f:
        promtail_version = f.readlines()[0].strip()

    output_dir = os.path.join(output_dir, "promtail")
    output_zip = os.path.join(output_dir, "promtail.zip")

    response = requests.get(
        "https://github.com/grafana/loki/releases/download/v%s/promtail-linux-amd64.zip"
        % promtail_version,
        stream=True,
    )
    with open(output_zip, "wb") as f:
        for chunk in response.iter_content(chunk_size=512):
            f.write(chunk)

    with zipfile.ZipFile(output_zip) as f:
        f.extractall(output_dir)

    promtail_exe = os.path.join(output_dir, "promtail-linux-amd64")
    os.chmod(
        promtail_exe,
        os.stat(promtail_exe).st_mode | stat.S_IEXEC | stat.S_IXGRP | stat.S_IXOTH,
    )
    os.remove(output_zip)


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
            f"{output_dir}/{resource}",
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
        with open(f"{charts_path}/{chart}/VERSION", "r") as f:
            chart_version = f.readlines()[0].strip()
        command = ["helm"]
        command.append("upgrade" if chart_name in installed_charts else "install")
        command += [
            chart_name,
            repo,
            "--version",
            chart_version,
            "--values",
            f"{output_dir}/{chart}.yaml",
            "--namespace",
            namespace,
        ]
        try:
            print(subprocess.check_output(command).decode("utf-8"))
        except subprocess.CalledProcessError as err:
            print(err.output)


def install(config_manager, output_dir, dryrun, update_repo):
    """Create the final configuration for the helm charts and Kubernetes resources
    and install them to Kubernetes, if not run in --dryrun mode.

    Arguments:
        config_manager {AbstractConfigManager} -- ConfigManager that contains the
          configuration of the monitoring setup to be uninstalled.
        output_dir {string} -- Path to the directory where the generated files
          should be safed in
        dryrun {boolean} -- Whether the installation will be run in dryrun mode
        update_repo {boolean} -- Whether to update the helm repositories locally
    """
    config = config_manager.get_config()

    if not os.path.exists(output_dir):
        os.mkdir(output_dir)

    _run_ytt(config, output_dir)

    namespace = config_manager.get_config()["namespace"]
    _create_dashboard_configmaps(output_dir, namespace)

    if os.path.exists(os.path.join(output_dir, "promtail.yaml")):
        _create_promtail_configs(config, output_dir)
        if not dryrun:
            _download_promtail(output_dir)

    if not dryrun:
        if update_repo:
            _update_helm_repos()
        _deploy_loose_resources(output_dir)
        _install_or_update_charts(output_dir, namespace)
