local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;
local gauge = grafana.gaugePanel;

gauge.new(
  title='REST API latency (0.99 quantile)',
  unit='ms',
  min=0,
  max=50,
)
.addTarget(
  target=prometheus.target(
    'http_server_rest_api_server_latency_total{quantile="0.99", instance="$instance",replica="$replica"}',
    legendFormat=' ',
    intervalFactor=1,
    instant=true,
  ),
)
.addThresholds([
  {
    color: 'green',
    value: null
  },
  {
    color: 'red',
    value: 30
  }
])
