local grafana = import '../../../vendor/grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local template = grafana.template;
local graphPanel = grafana.graphPanel;
local prometheus = grafana.prometheus;

local defaults = import '../../globals/defaults.libsonnet';
local gridPos = import '../../globals/grid_pos.libsonnet';
local variables = import '../globals/variables.libsonnet';

local account_cache_misses_panel = import './panels/account_cache_misses.libsonnet';
local change_cache_misses_panel = import './panels/change_cache_misses.libsonnet';
local conflict_cache_misses_panel = import './panels/conflict_cache_misses.libsonnet';
local diff_cache_misses_panel = import './panels/diff_cache_misses.libsonnet';
local misc_cache_misses_panel = import './panels/misc_cache_misses.libsonnet';
local project_cache_misses_panel = import './panels/project_cache_misses.libsonnet';

dashboard.new(
  'Gerrit - Caches',
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
  account_cache_misses_panel,
  gridPos=gridPos.new(0, 0)
)
.addPanel(
  change_cache_misses_panel,
  gridPos=gridPos.new(0, 1)
)
.addPanel(
  conflict_cache_misses_panel,
  gridPos=gridPos.new(1, 0)
)
.addPanel(
  project_cache_misses_panel,
  gridPos=gridPos.new(1, 1)
)
.addPanel(
  diff_cache_misses_panel,
  gridPos=gridPos.new(2, 0)
)
.addPanel(
  misc_cache_misses_panel,
  gridPos=gridPos.new(2, 1)
)
