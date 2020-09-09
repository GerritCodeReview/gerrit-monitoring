local target = import './cache_target.libsonnet';
local lineGraph = import '../../../globals/line-graph.libsonnet';

lineGraph.new(
  title='CHANGE cache misses',
  labelY1='Cache Misses',
  formatY1='percent',
  fill=0,
)
.addTarget(target.new('change_kind'))
.addTarget(target.new('change_notes'))
.addTarget(target.new('changeid_project'))
