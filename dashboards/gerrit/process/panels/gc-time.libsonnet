local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

local barGraph = import '../../../globals/bar-graph.libsonnet';

barGraph.new(
  title='Java - % of time spent in GC',
  formatY1='percentunit',
  labelY1='GC Time',
)
.addTarget(
  prometheus.target(
    'increase(proc_jvm_gc_time_G1_Young_Generation{instance="$instance",replica="$replica"}[2m])/increase(proc_uptime{instance="$instance",replica="$replica"}[2m])',
    legendFormat='gc time G1 young gen',
    interval='1m',
  )
)
.addTarget(
  prometheus.target(
    'increase(proc_jvm_gc_time_G1_Old_Generation{instance="$instance",replica="$replica"}[2m])/increase(proc_uptime{instance="$instance",replica="$replica"}[2m])',
    legendFormat='gc time G1 old gen',
    interval='1m',
  )
)
.addTarget(
  prometheus.target(
    'increase(proc_jvm_gc_time_PS_MarkSweep{instance="$instance",replica="$replica"}[2m])/increase(proc_uptime{instance="$instance",replica="$replica"}[2m])',
    legendFormat='gc time PS MarkSweep',
    interval='1m',
  )
)
.addTarget(
  prometheus.target(
    'increase(proc_jvm_gc_time_PS_Scavenge{instance="$instance",replica="$replica"}[2m])/increase(proc_uptime{instance="$instance",replica="$replica"}[2m])',
    legendFormat='gc time PS Scavange',
    interval='1m',
  )
)
.addSeriesOverride(
  {
    alias: 'gc time G1 young gen',
    color: '#F2CC0C',
  }
)
.addSeriesOverride(
  {
    alias: 'gc time G1 young gen',
    color: '#3274D9',
  }
)
.addSeriesOverride(
  {
    alias: 'gc time PS Scavange',
    color: '#8AB8FF',
  }
)
.addSeriesOverride(
  {
    alias: 'gc time PS MarkSweep',
    color: '#E02F44',
  }
)
