from grafanalib.core import (
    Graph,
    Target,
    YAxes,
    YAxis,
    SHORT_FORMAT,
)

from globals.legends import table_legend

panel = Graph(
    title="JGit block cache",
    dataSource="Prometheus",
    targets=[
        Target(
            expr='increase(jgit_block_cache_miss_count{instance="$instance",replica="$replica"}[2m])/(increase(jgit_block_cache_hit_count{instance="$instance",replica="$replica"}[2m])+increase(jgit_block_cache_miss_count{instance="$instance",replica="$replica"}[2m]))',
            legendFormat="miss ratio",
        ),
        Target(
            expr='increase(jgit_block_cache_eviction_count{instance="$instance",replica="$replica"}[2m])/(increase(jgit_block_cache_hit_count{instance="$instance",replica="$replica"}[2m])+increase(jgit_block_cache_miss_count{instance="$instance",replica="$replica"}[2m]))',
            legendFormat="eviction ratio",
        ),
    ],
    yAxes=YAxes(
        YAxis(format="percentunit", label="miss ratio"),
        YAxis(format="percentunit", label="eviction ratio"),
    ),
    legend=table_legend,
)
