local grafana = import '../../../vendor/grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local template = grafana.template;
local row = grafana.row;
local graphPanel = grafana.graphPanel;
local prometheus = grafana.prometheus;

local defaults = import '../../globals/defaults.libsonnet';
local gridPos = import '../../globals/grid_pos.libsonnet';
local variables = import '../globals/variables.libsonnet';

local availability_panel = import './panels/availability.libsonnet';
local availability_time_panel = import './panels/availability-time.libsonnet';
local cpu_usage_panel = import './panels/cpu-usage.libsonnet';
local events_panel = import './panels/events.libsonnet';
local git_panel = import './panels/git-fetch-clone.libsonnet';
local heap_usage_panel = import './panels/heap-usage.libsonnet';
local http_responses_panel = import './panels/http-responses.libsonnet';
local request_errors_panel = import './panels/request-errors.libsonnet';
local rest_latency_panel = import './panels/rest-latency.libsonnet';
local threads_panel = import './panels/threads.libsonnet';
local version_table_panel = import './panels/version-table.libsonnet';

dashboard.new(
  'Gerrit - Overview',
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
  version_table_panel,
  gridPos={
    w: 24,
    h: 3,
    x: 0,
    y: 0,
  },
)
.addPanel(
  cpu_usage_panel,
  gridPos=gridPos.new(1,0,3,height=6),
)
.addPanel(
  heap_usage_panel,
  gridPos=gridPos.new(1,1,3,height=6),
)
.addPanel(
  threads_panel,
  gridPos=gridPos.new(1,2,3,height=6),
)
.addPanel(
  rest_latency_panel,
  gridPos=gridPos.new(2,0,3,height=6),
)
.addPanel(
  request_errors_panel,
  gridPos=gridPos.new(2,1,3,height=6),
)
.addPanel(
  row.new(title=''),
  gridPos={
    w: 24,
    h: 1,
    x: 0,
    y: 15,
  },
)
.addPanel(
  availability_time_panel,
  gridPos={
    w: 18,
    h: 11,
    x: 0,
    y: 15,
  },
)
.addPanel(
  availability_panel,
  gridPos={
    w: 6,
    h: 11,
    x: 18,
    y: 15,
  },
)
.addPanel(
  events_panel,
  gridPos={
    w: 18,
    h: 11,
    x: 0,
    y: 30,
  },
)
.addPanel(
  git_panel,
  gridPos={
    w: 6,
    h: 11,
    x: 18,
    y: 30,
  },
)
.addPanel(
  http_responses_panel,
  gridPos=gridPos.new(4,0,1, height=22),
)
