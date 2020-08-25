local grafana = import '../../../vendor/grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local template = grafana.template;
local graphPanel = grafana.graphPanel;
local prometheus = grafana.prometheus;

local defaults = import '../../globals/defaults.libsonnet';
local gridPos = import '../../globals/grid_pos.libsonnet';
local publishVariables = import '../../globals/publish.libsonnet';
local variables = import '../globals/variables.libsonnet';

local cpu_panel = import './panels/cpu.libsonnet';
local file_descr_panel = import './panels/file-descriptors.libsonnet';
local gc_time_panel = import './panels/gc-time.libsonnet';
local jgit_block_cache_panel = import './panels/jgit-block-cache.libsonnet';
local memory_panel = import './panels/memory.libsonnet';
local system_load_panel = import './panels/system-load.libsonnet';
local threads_panel = import './panels/threads.libsonnet';

dashboard.new(
  'Gerrit - Process',
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
  system_load_panel,
  gridPos=gridPos.new(0, 0)
)
.addPanel(
  memory_panel,
  gridPos=gridPos.new(0, 1)
)
.addPanel(
  cpu_panel,
  gridPos=gridPos.new(1, 0)
)
.addPanel(
  gc_time_panel,
  gridPos=gridPos.new(1, 1)
)
.addPanel(
  threads_panel,
  gridPos=gridPos.new(2, 0)
)
.addPanel(
  file_descr_panel,
  gridPos=gridPos.new(2, 1)
)
.addPanel(
  jgit_block_cache_panel,
  gridPos=gridPos.new(3, 0)
)
+ if std.extVar('publish') then publishVariables else {}
