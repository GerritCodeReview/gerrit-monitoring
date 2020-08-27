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


def get_gc_query(gc_name):
    return (
        f'increase(proc_jvm_gc_time_{gc_name}{{instance="$instance",replica="$replica"}}[2m])'
        f'/increase(proc_uptime{{instance="$instance",replica="$replica"}}[2m])'
    )


panel = Graph(
    title="Java - % of time spent in GC",
    dataSource="Prometheus",
    bars=True,
    lines=False,
    targets=[
        Target(
            expr=get_gc_query("G1_Young_Generation"),
            legendFormat="gc time G1 young gen",
            interval="1m",
        ),
        Target(
            expr=get_gc_query("G1_Old_Generation"),
            legendFormat="gc time G1 old gen",
            interval="1m",
        ),
        Target(
            expr=get_gc_query("PS_MarkSweep"),
            legendFormat="gc time PS MarkSweep",
            interval="1m",
        ),
        Target(
            expr=get_gc_query("PS_Scavenge"),
            legendFormat="gc time PS Scavenge",
            interval="1m",
        ),
    ],
    yAxes=YAxes(YAxis(format="percentunit", label="GC Time")),
    legend=table_legend,
    seriesOverrides=[
        {"alias": "gc time G1 young gen", "color": "#3274D9",},
        {"alias": "gc time G1 old gen", "color": "#F2CC0C",},
        {"alias": "gc time PS Scavenge", "color": "#8AB8FF",},
        {"alias": "gc time PS MarkSweep", "color": "#E02F44",},
    ],
)
