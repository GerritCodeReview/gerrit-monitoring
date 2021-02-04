local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

local barGraph = import '../../../globals/bar-graph.libsonnet';
local yAxis = import '../../../globals/yaxis.libsonnet';

barGraph.new(
  title='Java - % of time spent in GC',
  yAxis1=yAxis.new(
    label='Open File Descriptors',
    format='percentunit',
  ),
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
.addTarget(
  prometheus.target(
    'increase(proc_jvm_gc_time_ZGC{instance="$instance",replica="$replica"}[2m])/increase(proc_uptime{instance="$instance",replica="$replica"}[2m])',
    legendFormat='gc time ZGC',
    interval='1m',
  )
)
.addTarget(
  prometheus.target(
    'increase(proc_jvm_gc_time_ShenandoahGC{instance="$instance",replica="$replica"}[2m])/increase(proc_uptime{instance="$instance",replica="$replica"}[2m])',
    legendFormat='gc time ShenandoahGC',
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
.addSeriesOverride(
  {
    alias: 'gc time ZGC',
    color: '#3274D9',
  }
)
.addSeriesOverride(
  {
    alias: 'gc time ShenandoahGC',
    color: '#3274D9',
  }
)