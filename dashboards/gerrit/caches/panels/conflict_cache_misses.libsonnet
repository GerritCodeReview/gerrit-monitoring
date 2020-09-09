local target = import './cache_target.libsonnet';
local lineGraph = import '../../../globals/line-graph.libsonnet';

lineGraph.new(
  title='CONFLICT cache misses',
  labelY1='Cache Misses',
  formatY1='percent',
  fill=0,
)
.addTarget(target.new('conflicts'))
.addTarget(target.new('mergeability'))
