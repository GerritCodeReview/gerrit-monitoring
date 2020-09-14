local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

local lineGraph = import '../../../globals/line-graph.libsonnet';
local yAxis = import '../../../globals/yaxis.libsonnet';

lineGraph.new(
  title='Gerrit Availability',
  yAxis1=yAxis.new(label='Count'),
  legend=false,
  min=0,
  max=1,
)
.addTarget(
  prometheus.target(
    'up{instance="$instance",replica="$replica"}',
    legendFormat='{{instance}}',
  )
)
