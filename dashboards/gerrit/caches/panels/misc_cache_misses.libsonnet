local target = import './cache_target.libsonnet';
local lineGraph = import '../../../globals/line-graph.libsonnet';
local yAxis = import '../../../globals/yaxis.libsonnet';

lineGraph.new(
  title='MISC cache misses',
  yAxis1=yAxis.cache_misses,
  fill=0,
)
.addTarget(target.new('web_sessions'))
.addTarget(target.new('sshkeys'))
.addTarget(target.new('git_tags'))
.addTarget(target.new('permission_sort'))
