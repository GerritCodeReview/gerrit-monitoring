local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;
local gauge = grafana.gaugePanel;

gauge.new(
  title='CPU Usage',
  datasource='Prometheus',
)
.addTarget(
  target=prometheus.target(
    '(rate(proc_cpu_usage{instance="$instance",replica="$replica"}[2m])/proc_cpu_num_cores{instance="$instance",replica="$replica"})*100',
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
    value: 60
  },
  {
    color: 'red',
    value: 90
  }
])
