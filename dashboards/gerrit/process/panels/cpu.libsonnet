local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

local lineGraph = import '../../../globals/line-graph.libsonnet';

lineGraph.new(
  title='CPU',
  labelY1='CPU cores',
)
.addTarget(
  prometheus.target(
    'rate(proc_cpu_usage{instance="$instance",replica="$replica"}[5m])',
    legendFormat='used CPUs',
  )
)
.addTarget(
  prometheus.target(
    'proc_cpu_num_cores{instance="$instance",replica="$replica"}',
    legendFormat='available CPUs',
  )
)
.addSeriesOverride(
  {
    alias: 'available CPUs',
    color: '#1F60C4',
    fill: 0,
  }
)
