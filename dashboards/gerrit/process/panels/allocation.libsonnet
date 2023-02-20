local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local graphPanel = grafana.graphPanel;
local prometheus = grafana.prometheus;

local lineGraph = import '../../../globals/line-graph.libsonnet';
local yAxis = import '../../../globals/yaxis.libsonnet';

lineGraph.new(
  title='Memory Allocation',
  yAxis1=yAxis.new(
    label='Memory Allocation Rate',
    format='Bps',
    logBase=10,
  ),
)
.addTarget(
  prometheus.target(
    'rate(proc_jvm_memory_allocated{instance="$instance",replica="$replica"}[$__rate_interval])',
    legendFormat='memory allocation rate',
  )
)
