local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

local lineGraph = import '../../../globals/line-graph.libsonnet';
local yAxis = import '../../../globals/yaxis.libsonnet';
{
  new(type):: lineGraph.new(
    title=std.format('upload-pack pack bytes %s', type),
    yAxis1=yAxis.new(
      format='decbytes',
      logBase=10,
    ),
    min=1000,
    max=10000000000,
    fill=0,
  )
  .addTarget(
    prometheus.target(
      std.format('git_upload_pack_pack_bytes_%s{instance="$instance",replica="$replica"}', type),
      legendFormat='quantile: {{quantile}}',
    )
  )
  .addSeriesOverride(
    {
      alias: 'quantile: 0.99',
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
      alias: 'quantile: 0.95',
      hiddenSeries: true,
    }
  )
  .addSeriesOverride(
    {
      alias: 'quantile: 0.75',
      hiddenSeries: true,
    }
  )
}
