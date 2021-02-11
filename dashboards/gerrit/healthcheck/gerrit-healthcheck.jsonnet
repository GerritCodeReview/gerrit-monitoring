local grafana = import '../../../vendor/grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local template = grafana.template;

local defaults = import '../../globals/defaults.libsonnet';
local gridPos = import '../../globals/grid_pos.libsonnet';
local publishVariables = import '../../globals/publish.libsonnet';
local variables = import '../globals/variables.libsonnet';

local healthcheck_panel = import './panels/healthcheck.libsonnet';

local HEALTHCHECKS = [
  'activeworkers',
  'auth',
  'deadlock',
  'httpactiveworkers',
  'jgit',
  'projectslist',
  'querychanges',
  'reviewdb'
];

dashboard.new(
  'Gerrit - Healthcheck',
  tags=['gerrit'],
  schemaVersion=defaults.dashboards.schemaVersion,
  editable=defaults.dashboards.editable,
  time_from=defaults.dashboards.timeFrom,
  time_to=defaults.dashboards.timeTo,
  refresh=defaults.dashboards.refresh,
  graphTooltip='shared_tooltip',
)
.addTemplate(variables.instance)
.addTemplate(variables.replica)
.addTemplate(
  template.new(
    name='check',
    datasource='Prometheus',
    query='metrics(^plugins_healthcheck_.+_failure_total$)',
    regex='plugins_healthcheck_(.+)_failure_total',
    label='Check',
    multi=true,
    includeAll=true,
    refresh='time',
  )
)
.addPanel(
  healthcheck_panel.new() + {
    repeat: 'check',
    repeatDirection: 'h',
    maxPerRow: 3,
  },
  gridPos={w: 8, h: 6})
+ if std.extVar('publish') then publishVariables else {}
