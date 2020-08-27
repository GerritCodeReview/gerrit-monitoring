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
    title="Memory",
    dataSource="Prometheus",
    targets=[
        Target(
            expr='proc_jvm_memory_heap_committed{instance="$instance",replica="$replica"}',
            legendFormat="committed heap",
        ),
        Target(
            expr='proc_jvm_memory_heap_used{instance="$instance",replica="$replica"}',
            legendFormat="used heap",
        ),
        Target(
            expr='jgit_block_cache_cache_used{instance="$instance",replica="$replica"}',
            legendFormat="JGit block cache",
        ),
        Target(
            expr='proc_jvm_memory_non_heap_used{instance="$instance",replica="$replica"}',
            legendFormat="used non-heap",
        ),
    ],
    yAxes=YAxes(YAxis(format="decbytes", label="Memory Consumption")),
    legend=table_legend,
)
