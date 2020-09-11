local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local graphPanel = grafana.graphPanel;
local prometheus = grafana.prometheus;

local lineGraph = import '../../../globals/line-graph.libsonnet';
local yAxis = import '../../../globals/yaxis.libsonnet';

{
  new(
      metric,
      title,
      label,
  ):: lineGraph.new(
    title=title,
    yAxis1=yAxis.new(
      label=label,
      format='ms',
      logBase=10,
    ),
  )
  .addTarget(
    prometheus.target(
      std.format(
        '%s{instance="$instance",replica="$replica"}', metric),
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
}
