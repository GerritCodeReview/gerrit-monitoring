local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;
local gauge = grafana.gaugePanel;

local defaults = import '../../../globals/defaults.libsonnet';

gauge.new(
  title='HTTP Request Error Rate (last 5 min)',
  datasource=defaults.datasource,
  description='Excludes 404 and 401, since these error codes are caused by client behaviour and are overrepresented in the data.',
  min=0,
  max=100,
)
.addTarget(
  target=prometheus.target(
    '(increase(http_server_error_count_total_total{instance="$instance",replica="$replica"}[5m]) - increase(http_server_error_count_404_total{instance=\"$instance\",replica=\"$replica\"}[5m]) - increase(http_server_error_count_401_total{instance=\"$instance\",replica=\"$replica\"}[5m])) / (increase(http_server_success_count_total_total{instance=\"$instance\",replica=\"$replica\"}[5m]) + increase(http_server_error_count_total_total{instance=\"$instance\",replica=\"$replica\"}[5m]) - increase(http_server_error_count_404_total{instance=\"$instance\",replica=\"$replica\"}[5m]) - increase(http_server_error_count_401_total{instance="$instance",replica="$replica"}[5m]))*100',
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
    color: 'orange',
    value: 5
  },
  {
    color: 'red',
    value: 10
  }
])
