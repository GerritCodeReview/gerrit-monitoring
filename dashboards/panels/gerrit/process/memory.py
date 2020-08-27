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
