local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

local barGraph = import '../../../globals/bar-graph.libsonnet';
local yAxis = import '../../../globals/yaxis.libsonnet';

local events = [
  'assignee_changed',
  'change_abandoned',
  'change_merged',
  'comment_added',
  'patchset_created',
  'change_abandoned',
  'ref_replicated',
  'ref_updated',
  'reviewer_added',
  'reviewer_deleted',
  'topic_changed',
  'vote_deleted',
  'wip_state_changed',
];

barGraph.new(
  title='Gerrit Events (last 5 min)',
  yAxis1=yAxis.new(label='Count [5 min]'),
  x_axis_mode='series',
  x_axis_values='current',
  legend=false,
)
.addTargets([
  prometheus.target(
    std.format('increase(events_%s_total{instance="$instance",replica="$replica"}[5m])', event),
    legendFormat=std.strReplace(event, '_', ' '),
    intervalFactor=1,
    instant=true,
  ) for event in events
])
