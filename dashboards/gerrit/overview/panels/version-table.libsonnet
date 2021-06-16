local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;
local table = grafana.tablePanel;

local defaults = import '../../../globals/defaults.libsonnet';

table.new(
  title='Gerrit Version',
  datasource=defaults.datasource,
  transform='table',
  transparent=false,
)
.addTarget(
  prometheus.target(
    'max(gerrit_build_info{instance="$instance",replica="$replica"}) by (instance, version, revision, javaversion)',
    instant=true,
    format='table',
  )
)
.addColumn(
  field='instance',
  style={
    alias: 'Gerrit instance',
    pattern: 'instance',
    type: 'string',
    link: true,
    linkTargetBlank: true,
    linkUrl: 'https://${__cell:raw}',
    linkTooltip: 'Link to the Gerrit instance',
  },
)
.addColumn(
  field='version',
  style={
    alias: 'Gerrit version',
    pattern: 'version',
    type: 'string',
  },
)
.addColumn(
  field='revision',
  style={
    alias: 'Gerrit revision',
    pattern: 'revision',
    type: 'string',
    link: true,
    linkTargetBlank: true,
    linkUrl: 'https://gerrit.googlesource.com/gerrit/+/${__cell:raw}',
    linkTooltip: 'Browse Gerrit repository at revision',
  },
)
.addColumn(
  field='javaversion',
  style={
    alias: 'Java version',
    pattern: 'javaversion',
    type: 'string',
  },
)
.hideColumn('Time')
.hideColumn('Value')
