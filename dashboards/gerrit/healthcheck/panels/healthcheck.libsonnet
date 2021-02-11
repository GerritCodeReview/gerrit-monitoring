local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local statPanel = grafana.statPanel;
local prometheus = grafana.prometheus;

local defaults = import '../../../globals/defaults.libsonnet';

{
  new():: statPanel.new(
    datasource=defaults.datasource,
    decimals=2,
    displayName='${check}',
    title='',
    unit='percent',
  )
  .addTarget(
    prometheus.target(
      '100-clamp_max(increase(plugins_healthcheck_${check}_failure_total{instance="$instance",replica="$replica"}[2m]), 1)*100',
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
