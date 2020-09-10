local grafana = import '../../../vendor/grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local template = grafana.template;
local graphPanel = grafana.graphPanel;
local prometheus = grafana.prometheus;

local defaults = import '../../globals/defaults.libsonnet';
local gridPos = import '../../globals/grid_pos.libsonnet';
local variables = import '../globals/variables.libsonnet';

local latency_panel = import './panels/latency.libsonnet';

dashboard.new(
  'Gerrit - Latency',
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
    title='RECEIVE-COMMIT latency'
  ),
  gridPos=gridPos.new(0, 0)
)
.addPanel(
  latency_panel.new(
    metric='http_server_rest_api_server_latency_total',
    title='REST total latency'
  ),
  gridPos=gridPos.new(0, 1)
)
.addPanel(
  latency_panel.new(
    metric='query_query_latency_total',
    title='QUERY total latency'
  ),
  gridPos=gridPos.new(1, 0)
)
.addPanel(
  latency_panel.new(
    metric='http_server_rest_api_server_latency_restapi_change_GetDetail',
    title='REST get change detail latency'
  ),
  gridPos=gridPos.new(1, 1)
)
.addPanel(
  latency_panel.new(
    metric='query_query_latency_changes',
    title='QUERY changes latency'
  ),
  gridPos=gridPos.new(2, 0)
)
.addPanel(
  latency_panel.new(
    metric='http_server_rest_api_server_latency_restapi_change_GetDiff',
    title='REST get change diff latency'
  ),
  gridPos=gridPos.new(2, 1)
)
.addPanel(
  latency_panel.new(
    metric='http_server_rest_api_server_latency_restapi_change_ListChangeComments',
    title='REST change list comments latency'
  ),
  gridPos=gridPos.new(3, 0)
)
.addPanel(
  latency_panel.new(
    metric='http_server_rest_api_server_latency_restapi_change_GetChange',
    title='REST get change latency'
  ),
  gridPos=gridPos.new(3, 1)
)
.addPanel(
  latency_panel.new(
    metric='http_server_rest_api_server_latency_restapi_change_ListChangeRobotComments',
    title='REST change list robot comments latency'
  ),
  gridPos=gridPos.new(4, 0)
)
.addPanel(
  latency_panel.new(
    metric='http_server_rest_api_server_latency_restapi_change_GetCommit',
    title='REST get commit latency'
  ),
  gridPos=gridPos.new(4, 1)
)
.addPanel(
  latency_panel.new(
    metric='http_server_rest_api_server_latency_restapi_change_PostReview',
    title='REST post change review latency'
  ),
  gridPos=gridPos.new(5, 0)
)
.addPanel(
  latency_panel.new(
    metric='http_server_rest_api_server_latency_restapi_change_GetRevisionActions',
    title='REST get change revision actions latency'
  ),
  gridPos=gridPos.new(5, 1)
)
