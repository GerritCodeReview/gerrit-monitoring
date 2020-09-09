local target = import './cache_target.libsonnet';
local lineGraph = import '../../../globals/line-graph.libsonnet';

lineGraph.new(
  title='DIFF cache misses',
  labelY1='Cache Misses',
  formatY1='percent',
  fill=0,
)
.addTarget(target.new('diff'))
.addTarget(target.new('diff_intraline'))
.addTarget(target.new('diff_summary'))
