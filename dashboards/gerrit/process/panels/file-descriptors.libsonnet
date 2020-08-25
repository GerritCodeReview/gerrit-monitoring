local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local graphPanel = grafana.graphPanel;
local prometheus = grafana.prometheus;

local lineGraph = import '../../../globals/line-graph.libsonnet';

lineGraph.new(
  title='Java open file descriptors',
  labelY1='Open File Descriptors',
  stack=true,
)
.addTarget(
  prometheus.target(
    'jgit_block_cache_open_files{instance="$instance",replica="$replica"}',
    legendFormat='jgit block cache',
  )
)
.addTarget(
  prometheus.target(
    'proc_num_open_fds{instance="$instance",replica="$replica"}-jgit_block_cache_open_files{instance="$instance",replica="$replica"}',
    legendFormat='other',
  )
)
