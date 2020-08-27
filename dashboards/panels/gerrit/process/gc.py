from grafanalib.core import (
    Graph,
    Target,
    YAxes,
    YAxis,
    SHORT_FORMAT,
)

from globals.legends import table_legend

panel = Graph(
    title="Java - % of time spent in GC",
    dataSource="Prometheus",
    bars=True,
    lines=False,
    targets=[
        Target(
            expr='increase(proc_jvm_gc_time_G1_Young_Generation{instance="$instance",replica="$replica"}[2m])/increase(proc_uptime{instance="$instance",replica="$replica"}[2m])',
            legendFormat="gc time G1 young gen",
            interval="1m",
        ),
        Target(
            expr='increase(proc_jvm_gc_time_G1_Old_Generation{instance="$instance",replica="$replica"}[2m])/increase(proc_uptime{instance="$instance",replica="$replica"}[2m])',
            legendFormat="gc time G1 old gen",
            interval="1m",
        ),
        Target(
            expr='increase(proc_jvm_gc_time_PS_MarkSweep{instance="$instance",replica="$replica"}[2m])/increase(proc_uptime{instance="$instance",replica="$replica"}[2m])',
            legendFormat="gc time PS MarkSweep",
            interval="1m",
        ),
        Target(
            expr='increase(proc_jvm_gc_time_PS_Scavenge{instance="$instance",replica="$replica"}[2m])/increase(proc_uptime{instance="$instance",replica="$replica"}[2m])',
            legendFormat="gc time PS Scavange",
            interval="1m",
        ),
    ],
    yAxes=YAxes(YAxis(format="percentunit", label="GC Time")),
    legend=table_legend,
    seriesOverrides=[
        {"alias": "gc time G1 young gen", "color": "#F2CC0C",},
        {"alias": "gc time G1 young gen", "color": "#3274D9",},
        {"alias": "gc time PS Scavange", "color": "#8AB8FF",},
        {"alias": "gc time PS MarkSweep", "color": "#E02F44",},
    ],
)
