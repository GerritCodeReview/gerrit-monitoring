local grafana = import '../../../vendor/grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local template = grafana.template;
local graphPanel = grafana.graphPanel;
local prometheus = grafana.prometheus;

local defaults = import '../../globals/defaults.libsonnet';
local gridPos = import '../../globals/grid_pos.libsonnet';
local variables = import '../globals/variables.libsonnet';

local auto_rebuild_latency_panel = import './panels/auto-rebuild-latency.libsonnet';
local ext_id_read_latency_panel = import './panels/read-all-ext-ids-latency.libsonnet';
local parse_latency_panel = import './panels/parse-latency.libsonnet';
local read_latency_panel = import './panels/read-latency.libsonnet';
local stage_update_latency_panel = import './panels/stage-update-latency.libsonnet';
local update_latency_panel = import './panels/update-latency.libsonnet';

dashboard.new(
  'Gerrit - NoteDB',
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
  update_latency_panel,
  gridPos=gridPos.new(0, 0)
)
.addPanel(
  stage_update_latency_panel,
  gridPos=gridPos.new(0, 1)
)
.addPanel(
  read_latency_panel,
  gridPos=gridPos.new(1, 0)
)
.addPanel(
  parse_latency_panel,
  gridPos=gridPos.new(1, 1)
)
.addPanel(
  ext_id_read_latency_panel,
  gridPos=gridPos.new(2, 0)
)
.addPanel(
  auto_rebuild_latency_panel,
  gridPos=gridPos.new(2, 1)
)
