local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local graphPanel = grafana.graphPanel;
local prometheus = grafana.prometheus;

local lineGraph = import '../../../globals/line-graph.libsonnet';

lineGraph.new(
  title='JGit block cache',
  formatY1='percentunit',
  labelY1='miss ratio',
  formatY2='percentunit',
  labelY2='eviction ratio',
)
.addTarget(
  prometheus.target(
    'increase(jgit_block_cache_miss_count{instance="$instance",replica="$replica"}[2m])/(increase(jgit_block_cache_hit_count{instance="$instance",replica="$replica"}[2m])+increase(jgit_block_cache_miss_count{instance="$instance",replica="$replica"}[2m]))',
    legendFormat='miss ratio',
  )
)
.addTarget(
  prometheus.target(
    'increase(jgit_block_cache_eviction_count{instance="$instance",replica="$replica"}[2m])/(increase(jgit_block_cache_hit_count{instance="$instance",replica="$replica"}[2m])+increase(jgit_block_cache_miss_count{instance="$instance",replica="$replica"}[2m]))',
    legendFormat='eviction ratio',
  )
)
