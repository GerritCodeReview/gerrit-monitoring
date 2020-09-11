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

dashboard.new(
  'Gerrit - PUSH Latency',
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
.addPanel(
  latency_panel.new(
    metric='receivecommits_latency_total',
    title='TOTAL receive-commits latency'
  ),
  gridPos=gridPos.new(0, 0, 1)
)
.addPanel(
  latency_panel.new(
    metric='receivecommits_latency_AUTOCLOSED',
    title='AUTOCLOSED receive-commits latency'
  ),
  gridPos=gridPos.new(1, 0)
)
.addPanel(
  latency_panel.new(
    metric='receivecommits_latency_CREATE_REPLACE',
    title='CREATE/REPLACE receive-commits latency'
  ),
  gridPos=gridPos.new(1, 1)
)
