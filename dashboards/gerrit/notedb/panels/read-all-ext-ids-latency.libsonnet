local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local graphPanel = grafana.graphPanel;
local prometheus = grafana.prometheus;

local lineGraph = import '../../../globals/line-graph.libsonnet';
local yAxis = import '../../../globals/yaxis.libsonnet';

lineGraph.new(
  title='External ID Read Latency',
  yAxis1=yAxis.latency,
)
.addTarget(
  prometheus.target(
    'notedb_read_all_external_ids_latency{instance="$instance",replica="$replica"}',
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
