local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

local barGraph = import '../../../globals/bar-graph.libsonnet';
local yAxis = import '../../../globals/yaxis.libsonnet';

local actions = [
  'FETCH',
  'CLONE'
];

barGraph.new(
  title='Git Fetch/Clone upload-pack requests (last 5 min)',
  yAxis1=yAxis.new(label='Count [5 min]'),
  x_axis_mode='series',
  x_axis_values='current',
  legend=false,
)
.addTargets([
  prometheus.target(
    std.format('increase(git_upload_pack_request_count_%s_total{instance="$instance",replica="$replica"}[5m])', action),
    legendFormat=action,
    intervalFactor=1,
    instant=true,
  ) for action in actions
])
