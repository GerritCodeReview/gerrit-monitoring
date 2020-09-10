local grafana = import '../../vendor/grafonnet/grafana.libsonnet';
local graphPanel = grafana.graphPanel;

local defaults = import './defaults.libsonnet';
local yAxis = import './yaxis.libsonnet';

{
  new(
    title,
    yAxis1,
    yAxis2=yAxis.new(),
    min=null,
    max=null,
    stack=false,
    fill=1,
  ):: graphPanel.new(
    title=title,
    labelY1=yAxis1.label,
    formatY1=yAxis1.format,
    logBase1Y=yAxis1.logBase,
    labelY2=yAxis2.label,
    formatY2=yAxis2.format,
    logBase2Y=yAxis2.logBase,
    min=min,
    max=max,
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
