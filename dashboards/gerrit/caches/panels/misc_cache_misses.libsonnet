local target = import './cache_target.libsonnet';
local lineGraph = import '../../../globals/line-graph.libsonnet';

lineGraph.new(
  title='MISC cache misses',
  labelY1='Cache Misses',
  formatY1='percent',
  fill=0,
)
.addTarget(target.new('web_sessions'))
.addTarget(target.new('sshkeys'))
.addTarget(target.new('git_tags'))
.addTarget(target.new('permission_sort'))
