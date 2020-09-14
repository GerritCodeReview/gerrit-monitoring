local grafana = import '../../vendor/grafonnet/grafana.libsonnet';
local graphPanel = grafana.graphPanel;

local defaults = import './defaults.libsonnet';
local yAxis = import './yaxis.libsonnet';

{
  new(
    title,
    yAxis1,
    yAxis2=yAxis.new(),
    x_axis_mode='time',
    x_axis_values='total',
    legend=true,
    min=null,
    max=null,
    stack=false,
  ):: graphPanel.new(
    title=title,
    labelY1=yAxis1.label,
    formatY1=yAxis1.format,
    logBase1Y=yAxis1.logBase,
    labelY2=yAxis2.label,
    formatY2=yAxis2.format,
    logBase2Y=yAxis2.logBase,
    x_axis_mode=x_axis_mode,
    x_axis_values=x_axis_values,
    min=min,
    max=max,
    stack=stack,
    datasource=defaults.datasource,
    fill=1,
    legend_show=legend,
    legend_alignAsTable=true,
    legend_avg=true,
    legend_current=true,
    legend_max=true,
    legend_min=true,
    legend_values=true,
    lines=false,
    bars=true
  ),
}
