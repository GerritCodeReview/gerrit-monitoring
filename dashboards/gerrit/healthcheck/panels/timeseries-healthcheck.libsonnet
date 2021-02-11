local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local graphPanel = grafana.graphPanel;
local prometheus = grafana.prometheus;

local defaults = import '../../../globals/defaults.libsonnet';

{
  new():: graphPanel.new(
    datasource=defaults.datasource,
    decimals=0,
    fill=5,
    min=0,
    max=1,
    title='${check}',
  )
  .addTarget(
    prometheus.target(
      '1-clamp_max(increase(plugins_healthcheck_${check}_failure_total{instance="$instance",replica="$replica"}[2m]), 1)',
      legendFormat='${check}'
    )
  )
}
