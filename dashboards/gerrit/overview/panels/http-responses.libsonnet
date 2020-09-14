local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

local barGraph = import '../../../globals/bar-graph.libsonnet';
local yAxis = import '../../../globals/yaxis.libsonnet';

local responses = {
  success: [200, 201, 204, 301, 304],
  err: [400, 401, 403, 404, 405, 409, 412, 422, 500, 501, 503],
};

barGraph.new(
  title='HTTP response status',
  yAxis1=yAxis.new(label='Count'),
  stack=true,
)
.addTargets([
  prometheus.target(
    std.format('(increase(http_server_success_count_%d_total{instance="$instance",replica="$replica"}[2m]))/2', response),
    legendFormat=std.format('%d', response),
    intervalFactor=1,
  ) for response in responses.success
])
.addTargets([
  prometheus.target(
    std.format('(increase(http_server_error_count_%d_total{instance="$instance",replica="$replica"}[2m]))/2', response),
    legendFormat=std.format('%d', response),
    intervalFactor=1,
  ) for response in responses.err
])
.addSeriesOverride({
  alias: '200',
  color: '#37872D'
})
.addSeriesOverride({
  alias: '201',
  color: '#56A64B'
})
.addSeriesOverride({
  alias: '204',
  color: '#73BF69'
})
.addSeriesOverride({
  alias: '301',
  color: 'rgb(110, 210, 110)'
})
.addSeriesOverride({
  alias: '304',
  color: 'rgb(150, 225, 150)'
})
.addSeriesOverride({
  alias: '400',
  color: '#FA6400'
})
.addSeriesOverride({
  alias: '401',
  color: '#FF780A',
  hiddenSeries: true
})
.addSeriesOverride({
  alias: '403',
  color: '#FF9830'
})
.addSeriesOverride({
  alias: '404',
  color: '#FFB357',
  hiddenSeries: true
})
.addSeriesOverride({
  alias: '409',
  color: '#FFCB7D'
})
.addSeriesOverride({
  alias: '412',
  color: '#E0B400'
})
.addSeriesOverride({
  alias: '422',
  color: '#F2CC0C'
})
.addSeriesOverride({
  alias: '500',
  color: '#C4162A'
})
.addSeriesOverride({
  alias: '501',
  color: '#E02F44'
})
.addSeriesOverride({
  alias: '503',
  color: '#F2495C'
})
