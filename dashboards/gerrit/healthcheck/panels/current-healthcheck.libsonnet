local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local statPanel = grafana.statPanel;
local prometheus = grafana.prometheus;

local defaults = import '../../../globals/defaults.libsonnet';

{
  new():: statPanel.new(
    colorMode='background',
    datasource=defaults.datasource,
    decimals=2,
    displayName='${check}',
    graphMode='none',
    title='',
  )
  .addTarget(
    prometheus.target(
      '1-clamp_max(increase(plugins_healthcheck_${check}_failure_total{instance="$instance",replica="$replica"}[2m]), 1)',
      instant=true,
    )
  )
  .addThresholds([
    {
      "color": "dark-red",
      "value": null
    },
    {
      "color": "semi-dark-green",
      "value": 1
    }
  ])
  .addMappings([
    {
      "from": "",
      "id": 1,
      "text": "ok",
      "to": "",
      "type": 1,
      "value": "1"
    },
    {
      "from": "",
      "id": 2,
      "text": "failed",
      "to": "",
      "type": 1,
      "value": "0"
    }
  ])
}
