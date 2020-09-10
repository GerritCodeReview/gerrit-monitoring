local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

local lineGraph = import '../../../globals/line-graph.libsonnet';
local yAxis = import '../../../globals/yaxis.libsonnet';

local STREAM_TARGET = 'stream threads';
local EMAIL_TARGET = 'email threads';
local RECEIVE_COMMIT_TARGET = 'receive-commit threads';

lineGraph.new(
  title='MISC queues',
  yAxis1=yAxis.new(label='Tasks'),
)
.addTarget(
  prometheus.target(
    'queue_ssh_stream_worker_scheduled_tasks{instance="$instance",replica="$replica"}',
    legendFormat=STREAM_TARGET,
  )
)
.addTarget(
  prometheus.target(
    'queue_send_email_scheduled_tasks{instance="$instance",replica="$replica"}',
    legendFormat=EMAIL_TARGET,
  )
)
.addTarget(
  prometheus.target(
    'queue_receive_commits_scheduled_tasks{instance="$instance",replica="$replica"}',
    legendFormat=RECEIVE_COMMIT_TARGET,
  )
)
.addSeriesOverride(
  {
    alias: STREAM_TARGET,
    color: '#8AB8FF',
  }
)
.addSeriesOverride(
  {
    alias: EMAIL_TARGET,
    color: '#96D98D',
  }
)
.addSeriesOverride(
  {
    alias: RECEIVE_COMMIT_TARGET,
    color: '#FF7383',
  }
)
