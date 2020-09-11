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
  'Gerrit - UI ACTIONS Latency',
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
    name='action',
    datasource='Prometheus',
    query='metrics(^http_server_rest_api_ui_actions_latency_[^_]+$)',
    regex='^http_server_rest_api_ui_actions_latency_(.+)$',
    label='Action',
    multi=true,
    includeAll=true,
    current='All',
    refresh='time',
  )
)
.addPanel(
  latency_panel.new(
    metric='http_server_rest_api_ui_actions_latency_$action',
    title='UI action $action'
  ) + {
    repeat: 'action',
    repeatDirection: 'h',
    maxPerRow: 2,
  },
  gridPos=gridPos.new(1, 0)
)
