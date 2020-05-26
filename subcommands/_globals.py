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

HELM_CHARTS = {
    "grafana": "stable/grafana",
    "prometheus": "stable/prometheus",
}

PLG_HELM_CHARTS = {
    "loki": "loki/loki",
    "promtail": "loki/promtail",
}

EFK_HELM_CHARTS = {
    "elasticsearch": "elastic/elasticsearch",
    "fluentbit": "stable/fluent-bit",
    "kibana": "elastic/kibana",
}


def get_helm_charts(config):
    """Return charts that are part of the configuration.

    Arguments:
        config {dict} -- Configuration of the monitoring setup

    Returns:
        dict -- Helm charts that are part of the configured monitoring setup
    """
    charts = HELM_CHARTS.copy()

    logging_stack = config["logging"]["stack"]

    if logging_stack == "PLG":
        charts.update(PLG_HELM_CHARTS)
    elif logging_stack == "EFK":
        charts.update(EFK_HELM_CHARTS)
        if not config["logging"]["kibana"]["enabled"]:
            charts.pop("kibana")

    return charts
