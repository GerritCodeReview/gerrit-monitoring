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

import subprocess

from ._globals import HELM_CHARTS


def _get_yn_response(message):
    while True:
        response = input(message)
        if response == "y":
            return True

        if response == "n":
            return False

        print("Unknown input.")


def _remove_helm_deployment(chart, namespace):
    deployment_name = f"{chart}-{namespace}"
    if _get_yn_response(
        f"This will remove the deployment {deployment_name}. Continue (y/n)? "
    ):
        command = ["helm", "uninstall", deployment_name, "-n", namespace]
        subprocess.check_output(command)


def _delete_namespace(namespace):
    if _get_yn_response(
        f"This will remove the namespace {namespace}. Continue (y/n)? "
    ):
        command = ["kubectl", "delete", "ns", namespace]
        subprocess.check_output(command)


def uninstall(config_manager):
    """Uninstalls the monitoring setup.

    Arguments:
        config_manager {AbstractConfigManager} -- ConfigManager that contains the
          configuration of the monitoring setup to be uninstalled.
    """
    namespace = config_manager.get_config()["namespace"]
    for chart in HELM_CHARTS:
        _remove_helm_deployment(chart, namespace)
    _delete_namespace(namespace)
