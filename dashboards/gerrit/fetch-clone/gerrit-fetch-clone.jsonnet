local grafana = import '../../../vendor/grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local template = grafana.template;
local graphPanel = grafana.graphPanel;
local prometheus = grafana.prometheus;

local defaults = import '../../globals/defaults.libsonnet';
local gridPos = import '../../globals/grid_pos.libsonnet';
local publishVariables = import '../../globals/publish.libsonnet';
local variables = import '../globals/variables.libsonnet';

local count_panel = import './panels/count.libsonnet';
local bytes_panel = import './panels/bytes.libsonnet';

dashboard.new(
  'Gerrit - Git Fetch & Clone',
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
  count_panel.new('CLONE'),
  gridPos=gridPos.new(0, 0)
)
.addPanel(
  count_panel.new('FETCH'),
  gridPos=gridPos.new(0, 1)
)
.addPanel(
  bytes_panel.new('CLONE'),
  gridPos=gridPos.new(1, 0)
)
.addPanel(
  bytes_panel.new('FETCH'),
  gridPos=gridPos.new(1, 1)
)
+ if std.extVar('publish') then publishVariables else {}
