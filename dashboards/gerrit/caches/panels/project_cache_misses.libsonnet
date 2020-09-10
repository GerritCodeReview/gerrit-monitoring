local target = import './cache_target.libsonnet';
local lineGraph = import '../../../globals/line-graph.libsonnet';
local yAxis = import '../../../globals/yaxis.libsonnet';

lineGraph.new(
  title='PROJECT cache misses',
  yAxis1=yAxis.cache_misses,
  fill=0,
)
.addTarget(target.new('project_list'))
.addTarget(target.new('projects'))
