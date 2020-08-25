local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local graphPanel = grafana.graphPanel;
local prometheus = grafana.prometheus;

local lineGraph = import '../../../globals/line-graph.libsonnet';

lineGraph.new(
  title='Threads',
  labelY1='Live Threads',
)
.addTarget(
  prometheus.target(
    'proc_jvm_thread_num_live{instance="$instance",replica="$replica"}',
    legendFormat='Java live threads',
  )
)
