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

dashboard.new(
  'Gerrit - REST API Latency',
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
    name='endpoint',
    datasource='Prometheus',
    query='metrics(^http_server_rest_api_server_latency_restapi_.+$)',
    regex='^http_server_rest_api_server_latency_restapi_([^_]+)_.+$',
    label='Endpoint',
    refresh='time',
  )
)
.addTemplate(
  template.new(
    name='action',
    datasource='Prometheus',
    query='metrics(^http_server_rest_api_server_latency_restapi_$endpoint.+$)',
    regex='^http_server_rest_api_server_latency_restapi_[^_]+_([^_]+)_.+$',
    label='Action',
    multi=true,
    includeAll=true,
    refresh='time',
  )
)
.addPanel(
  latency_panel.new(
    metric='http_server_rest_api_server_latency_total',
    title='REST total latency'
  ),
  gridPos=gridPos.new(0, 0, 1)
)
.addPanel(
  latency_panel.new(
    metric='http_server_rest_api_server_latency_restapi_${endpoint}_$action',
    title='REST ${endpoint} $action'
  ) + {
    repeat: 'action',
    repeatDirection: 'h',
    maxPerRow: 2,
  },
  gridPos=gridPos.new(1, 0)
)
+ if std.extVar('publish') then publishVariables else {}
