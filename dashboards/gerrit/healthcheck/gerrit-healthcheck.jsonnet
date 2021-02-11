local grafana = import '../../../vendor/grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local template = grafana.template;
local row = grafana.row;
local graphPanel = grafana.graphPanel;
local prometheus = grafana.prometheus;

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
.addPanels([
  healthcheck_panel.new(
    healthcheck=HEALTHCHECKS[i],
  ) { gridPos: {w: 12, h: 11, x: (i%2)*12} }
  for i in std.range(0, std.length(HEALTHCHECKS) - 1)
])
+ if std.extVar('publish') then publishVariables else {}
