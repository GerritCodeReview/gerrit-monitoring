from grafanalib.core import (
    Graph,
    Target,
    YAxes,
    YAxis,
    SHORT_FORMAT,
)

from globals.legends import table_legend

panel = Graph(
    title="System load",
    dataSource="Prometheus",
    targets=[
        Target(
            expr='proc_cpu_system_load{instance="$instance",replica="$replica"}',
            legendFormat="system load",
        )
    ],
    yAxes=YAxes(YAxis(format=SHORT_FORMAT)),
    legend=table_legend,
)
