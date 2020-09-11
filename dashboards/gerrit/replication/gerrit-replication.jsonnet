local grafana = import '../../../vendor/grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local template = grafana.template;
local row = grafana.row;
local graphPanel = grafana.graphPanel;
local prometheus = grafana.prometheus;

local defaults = import '../../globals/defaults.libsonnet';
local gridPos = import '../../globals/grid_pos.libsonnet';
local variables = import '../globals/variables.libsonnet';

local replication_panel = import './panels/replication.libsonnet';

dashboard.new(
  'Gerrit - Replication',
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
    name='target',
    datasource='Prometheus',
    query='metrics(plugins_replication_replication_latency_.*_count)',
    regex='^plugins_replication_replication_latency_(.*)_count$',
    label='Replication Target',
    multi=true,
    includeAll=true,
    refresh='time',
  )
)
.addPanel(
  replication_panel.new(
    metric='plugins_replication_replication_delay_$target',
    title='replication DELAY $target',
    label='delay',
  ) + {
    repeat: 'target',
    repeatDirection: 'v',
    maxPerRow: 2,
  },
  gridPos=gridPos.new(0, 0)
)
.addPanel(
  replication_panel.new(
    metric='plugins_replication_replication_latency_$target',
    title='replication LATENCY $target',
    label='latency',
  ) + {
    repeat: 'target',
    repeatDirection: 'v',
    maxPerRow: 2,
  },
  gridPos=gridPos.new(0, 1)
)
