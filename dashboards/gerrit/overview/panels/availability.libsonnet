local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;
local stat = grafana.singlestat;

local defaults = import '../../../globals/defaults.libsonnet';

stat.new(
  title='Gerrit Availability [last 24h]',
  datasource=defaults.datasource,
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
