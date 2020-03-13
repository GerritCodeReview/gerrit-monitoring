import subprocess

CHARTS = [
    "grafana",
    "loki",
    "prometheus",
]


def _get_yn_response(message):
    while True:
        response = input(message)
        if response == "y":
            return True

        if response == "n":
            return False

        print("Unknown input.")


def _remove_helm_deployment(chart, namespace):
    deployment_name = "%s-%s" % (chart, namespace)
    if _get_yn_response(
        "This will remove the deployment %s. Continue (y/n)? " % (deployment_name)
    ):
        command = ["helm", "uninstall", deployment_name, "-n", namespace]
        subprocess.check_output(command)


def uninstall(config_manager):
    """Uninstalls the monitoring setup.

    Arguments:
        config_manager {AbstractConfigManager} -- ConfigManager that contains the
          configuration of the monitoring setup to be uninstalled.
    """
    namespace = config_manager.get_config()["namespace"]
    for chart in CHARTS:
        _remove_helm_deployment(chart, namespace)
    if _get_yn_response(
        "This will remove the namespace %s. Continue (y/n)? " % namespace
    ):
        command = ["kubectl", "delete", "ns", namespace]
        subprocess.check_output(command)
