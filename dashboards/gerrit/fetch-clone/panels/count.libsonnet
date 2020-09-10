local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

local lineGraph = import '../../../globals/line-graph.libsonnet';
local yAxis = import '../../../globals/yaxis.libsonnet';

{
  new(type):: lineGraph.new(
    title=std.format('%s count', type),
    yAxis1=yAxis.new(
      format='opm',
    )
  )
  .addTarget(
    prometheus.target(
      std.format('increase(git_upload_pack_request_count_%s_total{instance="$instance",replica="$replica"}[2m])/2', type),
      legendFormat=type,
    )
  )
}
