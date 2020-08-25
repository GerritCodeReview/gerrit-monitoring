local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local graphPanel = grafana.graphPanel;
local prometheus = grafana.prometheus;

local lineGraph = import '../../../globals/line-graph.libsonnet';

lineGraph.new(
  title='System load',
  labelY1='System load',
)
.addTarget(
  prometheus.target(
    'proc_cpu_system_load{instance="$instance",replica="$replica"}',
    legendFormat='system load',
  )
)
