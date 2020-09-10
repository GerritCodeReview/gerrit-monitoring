local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local graphPanel = grafana.graphPanel;
local prometheus = grafana.prometheus;

local lineGraph = import '../../../globals/line-graph.libsonnet';
local yAxis = import '../../../globals/yaxis.libsonnet';

lineGraph.new(
  title='Threads',
  yAxis1=yAxis.new(label='Live Threads'),
)
.addTarget(
  prometheus.target(
    'proc_jvm_thread_num_live{instance="$instance",replica="$replica"}',
    legendFormat='Java live threads',
  )
)
