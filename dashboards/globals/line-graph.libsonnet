local grafana = import '../../vendor/grafonnet/grafana.libsonnet';
local graphPanel = grafana.graphPanel;

local defaults = import './defaults.libsonnet';

{
  new(
    title,
    labelY1,
    labelY2='',
    formatY1='short',
    formatY2='short',
    stack=false,
    fill=1,
  ):: graphPanel.new(
    title=title,
    labelY1=labelY1,
    labelY2=labelY2,
    formatY1=formatY1,
    formatY2=formatY2,
    stack=stack,
    datasource=defaults.datasource,
    fill=fill,
    legend_alignAsTable=true,
    legend_avg=true,
    legend_current=true,
    legend_max=true,
    legend_min=true,
    legend_values=true,
    lines=true,
    linewidth=1,
  ),
}
