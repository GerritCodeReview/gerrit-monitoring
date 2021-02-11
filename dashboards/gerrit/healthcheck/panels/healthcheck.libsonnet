local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local statPanel = grafana.statPanel;
local prometheus = grafana.prometheus;

local defaults = import '../../../globals/defaults.libsonnet';

{
  new(
      healthcheck
  ):: statPanel.new(
    datasource=defaults.datasource,
    decimals=2,
    displayName=healthcheck,
    title=std.format('%s check', std.asciiUpper(healthcheck)),
    unit='percent',
  )
  .addTarget(
    prometheus.target(
      std.format(
        '100-clamp_max(increase(plugins_healthcheck_%s_failure_total{instance="$instance",replica="$replica"}[2m]), 1)*100', healthcheck),
      legendFormat=healthcheck,
    )
  )
  .addThresholds([
    {
      "color": "dark-red",
      "value": null
    },
    {
      "color": "red",
      "value": 25
    },
    {
      "color": "dark-orange",
      "value": 50
    },
    {
      "color": "#EAB839",
      "value": 75
    },
    {
      "color": "semi-dark-green",
      "value": 100
    }
  ])
}
