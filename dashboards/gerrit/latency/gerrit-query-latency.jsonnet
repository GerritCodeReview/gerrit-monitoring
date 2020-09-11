local grafana = import '../../../vendor/grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local template = grafana.template;
local row = grafana.row;
local graphPanel = grafana.graphPanel;
local prometheus = grafana.prometheus;

local defaults = import '../../globals/defaults.libsonnet';
local gridPos = import '../../globals/grid_pos.libsonnet';
local variables = import '../globals/variables.libsonnet';

local latency_panel = import './panels/latency.libsonnet';

local QUERIES = ['accounts', 'changes', 'groups', 'projects'];

dashboard.new(
  'Gerrit - QUERY Latency',
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
.addPanel(latency_panel.new(
  metric='query_query_latency_total',
  title='TOTAL query latency',
),
gridPos=gridPos.new(0,0,1),
)
.addPanels([
  latency_panel.new(
    metric=std.format('query_query_latency_%s', QUERIES[i]),
    title=std.format('%s query latency', std.asciiUpper(QUERIES[i])),
  ) { gridPos: {w: 12, h: 11, x: (i%2)*12} }
  for i in std.range(0, std.length(QUERIES) - 1)
])
