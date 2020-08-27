from grafanalib.core import (
    Graph,
    Target,
    YAxes,
    YAxis,
    SHORT_FORMAT,
)

from globals.legends import table_legend

panel = Graph(
    title="Java open file descriptors",
    dataSource="Prometheus",
    stack=True,
    targets=[
        Target(
            expr='jgit_block_cache_open_files{instance="$instance",replica="$replica"}',
            legendFormat="jgit block cache",
        ),
        Target(
            expr='proc_num_open_fds{instance="$instance",replica="$replica"}-jgit_block_cache_open_files{instance="$instance",replica="$replica"}',
            legendFormat="other",
        ),
    ],
    yAxes=YAxes(YAxis(format=SHORT_FORMAT, label="Open File Descriptors")),
    legend=table_legend,
)
