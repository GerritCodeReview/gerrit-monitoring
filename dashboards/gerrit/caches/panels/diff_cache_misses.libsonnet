local target = import './cache_target.libsonnet';
local lineGraph = import '../../../globals/line-graph.libsonnet';
local yAxis = import '../../../globals/yaxis.libsonnet';

lineGraph.new(
  title='DIFF cache misses',
  yAxis1=yAxis.cache_misses,
  fill=0,
)
.addTarget(target.new('diff'))
.addTarget(target.new('diff_intraline'))
.addTarget(target.new('diff_summary'))
