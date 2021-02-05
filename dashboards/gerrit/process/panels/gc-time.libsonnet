local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

local barGraph = import '../../../globals/bar-graph.libsonnet';
local yAxis = import '../../../globals/yaxis.libsonnet';

local METRICS = [
  {
    name: 'G1_Young_Generation',
    label: 'gc time G1 young gen',
    color: '#3274D9',
  },
  {
    name: 'G1_Old_Generation',
    label: 'gc time G1 old gen',
    color: '#F2CC0C',
  },
  {
    name: 'PS_Scavenge',
    label: 'gc time PS Scavange',
    color: '#8AB8FF',
  },
  {
    name: 'PS_MarkSweep',
    label: 'gc time PS MarkSweep',
    color: '#E02F44',
  },
  {
    name: 'ZGC',
    label: 'gc time ZGC',
    color: '#BB95F0',
  },
  {
    name: 'ShenandoahGC',
    label: 'gc time ShenandoahGC',
    color: '#B4D61A',
  },
];

barGraph.new(
  title='Java - % of time spent in GC',
  yAxis1=yAxis.new(
    label='% of time spent in GC',
    format='percentunit',
  ),
)
.addTargets([
  prometheus.target(
    std.format('increase(proc_jvm_gc_time_%s{instance="$instance",replica="$replica"}[2m])/increase(proc_uptime{instance="$instance",replica="$replica"}[2m])', METRICS[i]['name']),
    legendFormat=METRICS[i]['label'],
    interval='1m',
  )
  for i in std.range(0, std.length(METRICS) - 1)
])
.addSeriesOverride(
  {
    alias: METRICS[0]['label'],
    color: METRICS[0]['color'],
  }
)
.addSeriesOverride(
  {
    alias: METRICS[1]['label'],
    color: METRICS[1]['color'],
  }
)
.addSeriesOverride(
  {
    alias: METRICS[2]['label'],
    color: METRICS[2]['color'],
  }
)
.addSeriesOverride(
  {
    alias: METRICS[3]['label'],
    color: METRICS[3]['color'],
  }
)
.addSeriesOverride(
  {
    alias: METRICS[4]['label'],
    color: METRICS[4]['color'],
  }
)
.addSeriesOverride(
  {
    alias: METRICS[5]['label'],
    color: METRICS[5]['color'],
  }
)