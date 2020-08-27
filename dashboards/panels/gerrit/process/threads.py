from grafanalib.core import (
    Graph,
    Target,
    YAxes,
    YAxis,
    SHORT_FORMAT,
)

from globals.legends import table_legend

panel = Graph(
    title="Threads",
    dataSource="Prometheus",
    targets=[
        Target(
            expr='proc_jvm_thread_num_live{instance="$instance",replica="$replica"}',
            legendFormat="Java live threads",
        )
    ],
    yAxes=YAxes(YAxis(format=SHORT_FORMAT, label="Live Threads")),
    legend=table_legend,
)
