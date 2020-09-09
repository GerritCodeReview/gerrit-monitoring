local target = import './cache_target.libsonnet';
local lineGraph = import '../../../globals/line-graph.libsonnet';

lineGraph.new(
  title='ACCOUNT cache misses',
  labelY1='Cache Misses',
  formatY1='percent',
  fill=0,
)
.addTarget(target.new('accounts'))
.addTarget(target.new('groups'))
.addTarget(target.new('groups_byuuid'))
.addTarget(target.new('ldap_groups_byinclude'))
