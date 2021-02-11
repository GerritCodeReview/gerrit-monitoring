local grafana = import '../../../vendor/grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local row = grafana.row;
local template = grafana.template;

local defaults = import '../../globals/defaults.libsonnet';
local gridPos = import '../../globals/grid_pos.libsonnet';
local publishVariables = import '../../globals/publish.libsonnet';
local variables = import '../globals/variables.libsonnet';

local current_healthcheck_panel = import './panels/current-healthcheck.libsonnet';
local timeseries_healthcheck_panel = import './panels/timeseries-healthcheck.libsonnet';

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
  row.new(title='CURRENT'),
  gridPos={x: 0, y: 0},
)
.addPanel(
  current_healthcheck_panel.new() + {
    repeat: 'check',
    repeatDirection: 'h',
    maxPerRow: 8,
  },
  gridPos={w: 3, h: 6})
.addPanel(
  row.new(title='OVER TIME'),
  gridPos={x: 0, y: 6},
)
.addPanel(
  timeseries_healthcheck_panel.new() + {
    repeat: 'check',
    repeatDirection: 'h',
    maxPerRow: 3,
  },
  gridPos={x: 0, y: 6, w: 8, h: 6})
+ if std.extVar('publish') then publishVariables else {}
