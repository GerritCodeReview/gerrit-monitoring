local target = import './cache_target.libsonnet';
local lineGraph = import '../../../globals/line-graph.libsonnet';
local yAxis = import '../../../globals/yaxis.libsonnet';

lineGraph.new(
  title='ACCOUNT cache misses',
  yAxis1=yAxis.cache_misses,
  fill=0,
)
.addTarget(target.new('accounts'))
.addTarget(target.new('groups'))
.addTarget(target.new('groups_byuuid'))
.addTarget(target.new('ldap_groups_byinclude'))
