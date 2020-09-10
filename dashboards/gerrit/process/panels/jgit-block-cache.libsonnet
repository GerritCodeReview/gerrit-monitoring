local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local graphPanel = grafana.graphPanel;
local prometheus = grafana.prometheus;

local lineGraph = import '../../../globals/line-graph.libsonnet';
local yAxis = import '../../../globals/yaxis.libsonnet';

lineGraph.new(
  title='JGit block cache',
  yAxis1=yAxis.new(
    label='miss ratio',
    format='percentunit',
  ),
  yAxis2=yAxis.new(
    label='eviction ratio',
    format='percentunit',
  ),
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
