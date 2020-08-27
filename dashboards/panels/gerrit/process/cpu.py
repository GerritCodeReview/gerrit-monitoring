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
