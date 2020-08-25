local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local graphPanel = grafana.graphPanel;
local prometheus = grafana.prometheus;

local lineGraph = import '../../../globals/line-graph.libsonnet';

lineGraph.new(
  title='Stage Update Latency',
  labelY1='Latency',
  formatY1='s',
)
.addTarget(
  prometheus.target(
    'notedb_stage_update_latency_total{instance="$instance",replica="$replica"}',
    legendFormat='quantile: {{quantile}}',
  )
)
.addSeriesOverride(
  {
    alias: 'quantile: 0.75',
    hiddenSeries: true,
  }
)
.addSeriesOverride(
  {
    alias: 'quantile: 0.98',
    hiddenSeries: true,
  }
)
.addSeriesOverride(
  {
    alias: 'quantile: 0.99',
    hiddenSeries: true,
  }
)
