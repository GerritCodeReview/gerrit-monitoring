local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;
local stat = grafana.singlestat;

stat.new(
  title='Gerrit Availability [last 24h]',
  datasource='Prometheus',
  colorBackground=true,
  colors=[
    "red",
    "orange",
    "darkgreen",
  ],
  format='percent',
  thresholds='98, 99',
  valueFontSize='150%',
  valueName='current',
)
.addTarget(
  prometheus.target(
    'avg_over_time(up{instance="$instance",replica="$replica"}[1d])*100',
    legendFormat='{{instance}}',
  )
)
