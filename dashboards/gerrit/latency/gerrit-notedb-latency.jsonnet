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

local latency_panel = import './panels/latency.libsonnet';

local ACTIONS = [
  'update',
  'stage_update',
  'read',
  'parse',
  'auto_rebuild',
];

dashboard.new(
  'Gerrit - NOTEDB Latency',
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
  latency_panel.new(
    metric=std.format('notedb_%s_latency_total', ACTIONS[i]),
    title=std.format('%s notedb latency', std.asciiUpper(ACTIONS[i])),
  ) { gridPos: {w: 12, h: 11, x: (i%2)*12} }
  for i in std.range(0, std.length(ACTIONS) - 1)
])
.addPanel(
  latency_panel.new(
    metric='notedb_read_all_external_ids_latency',
    title='READ ALL EXTERNAL IDS notedb latency'),
  gridPos={w: 12, h: 11, x: ((std.length(ACTIONS))%2)*12},
)
+ if std.extVar('publish') then publishVariables else {}
