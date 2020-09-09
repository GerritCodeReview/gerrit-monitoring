local target = import './cache_target.libsonnet';
local lineGraph = import '../../../globals/line-graph.libsonnet';

lineGraph.new(
  title='PROJECT cache misses',
  labelY1='Cache Misses',
  formatY1='percent',
  fill=0,
)
.addTarget(target.new('project_list'))
.addTarget(target.new('projects'))
