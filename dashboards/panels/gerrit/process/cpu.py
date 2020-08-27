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

from grafanalib.core import (
    Graph,
    Target,
    YAxes,
    YAxis,
    SHORT_FORMAT,
)

from globals.legends import table_legend

panel = Graph(
    title="CPU",
    dataSource="Prometheus",
    targets=[
        Target(
            expr='proc_cpu_system_load{instance="$instance",replica="$replica"}',
            legendFormat="system load",
        ),
        Target(
            expr='proc_cpu_num_cores{instance="$instance",replica="$replica"}',
            legendFormat="available CPUs",
        ),
    ],
    yAxes=YAxes(YAxis(format=SHORT_FORMAT, label="CPU cores")),
    legend=table_legend,
)
