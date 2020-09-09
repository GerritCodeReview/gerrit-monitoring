local grafana = import '../../../vendor/grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local template = grafana.template;
local graphPanel = grafana.graphPanel;
local prometheus = grafana.prometheus;

local defaults = import '../../globals/defaults.libsonnet';
local gridPos = import '../../globals/grid_pos.libsonnet';
local publishVariables = import '../../globals/publish.libsonnet';
local variables = import '../globals/variables.libsonnet';

local http_queue_panel = import './panels/http_queue.libsonnet';
local http_threads_panel = import './panels/http_threads.libsonnet';
local index_queue_panel = import './panels/index_queue.libsonnet';
local index_threads_panel = import './panels/index_threads.libsonnet';
local misc_queue_panel = import './panels/misc_queue.libsonnet';
local misc_threads_panel = import './panels/misc_threads.libsonnet';
local rest_api_request_rate_panel = import './panels/rest-api-request-rate.libsonnet';
local ssh_queue_panel = import './panels/ssh_queue.libsonnet';
local ssh_threads_panel = import './panels/ssh_threads.libsonnet';

dashboard.new(
  'Gerrit - Queues',
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
  ssh_threads_panel,
  gridPos=gridPos.new(0, 0, 3)
)
.addPanel(
  http_threads_panel,
  gridPos=gridPos.new(0, 1, 3)
)
.addPanel(
  index_threads_panel,
  gridPos=gridPos.new(0, 2, 3)
)
.addPanel(
  ssh_queue_panel,
  gridPos=gridPos.new(1, 0, 3)
)
.addPanel(
  http_queue_panel,
  gridPos=gridPos.new(1, 1, 3)
)
.addPanel(
  index_queue_panel,
  gridPos=gridPos.new(1, 2, 3)
)
.addPanel(
  misc_threads_panel,
  gridPos=gridPos.new(2, 0)
)
.addPanel(
  rest_api_request_rate_panel,
  gridPos=gridPos.new(2, 1)
)
.addPanel(
  misc_queue_panel,
  gridPos=gridPos.new(3, 0)
)
+ if std.extVar('publish') then publishVariables else {}
