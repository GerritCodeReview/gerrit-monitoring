local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

local lineGraph = import '../../../globals/line-graph.libsonnet';

local STREAM_TARGET = 'stream threads';
local STREAM_POOL_SIZE_TARGET = 'stream pool size';
local EMAIL_TARGET = 'email threads';
local EMAIL_POOL_SIZE_TARGET = 'email pool size';
local RECEIVE_COMMIT_TARGET = 'receive-commit threads';
local RECEIVE_COMMIT_POOL_SIZE_TARGET = 'receive-commit pool size';

lineGraph.new(
  title='MISC threads',
  labelY1='Threads',
)
.addTarget(
  prometheus.target(
    'queue_ssh_stream_worker_active_threads{instance="$instance",replica="$replica"}',
    legendFormat=STREAM_TARGET,
  )
)
.addTarget(
  prometheus.target(
    'queue_ssh_stream_worker_pool_size{instance="$instance",replica="$replica"}',
    legendFormat=STREAM_POOL_SIZE_TARGET,
  )
)
.addTarget(
  prometheus.target(
    'queue_send_email_active_threads{instance="$instance",replica="$replica"}',
    legendFormat=EMAIL_TARGET,
  )
)
.addTarget(
  prometheus.target(
    'queue_send_email_pool_size{instance="$instance",replica="$replica"}',
    legendFormat=EMAIL_POOL_SIZE_TARGET,
  )
)
.addTarget(
  prometheus.target(
    'queue_receive_commits_active_threads{instance="$instance",replica="$replica"}',
    legendFormat=RECEIVE_COMMIT_TARGET,
  )
)
.addTarget(
  prometheus.target(
    'queue_receive_commits_pool_size{instance="$instance",replica="$replica"}',
    legendFormat=RECEIVE_COMMIT_POOL_SIZE_TARGET,
  )
)
.addSeriesOverride(
  {
    alias: STREAM_TARGET,
    color: '#C0D8FF',
  }
)
.addSeriesOverride(
  {
    alias: STREAM_POOL_SIZE_TARGET,
    color: '#1F60C4',
    fill: 0,
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
    alias: EMAIL_POOL_SIZE_TARGET,
    color: '#37872D',
    fill: 0,
  }
)
.addSeriesOverride(
  {
    alias: RECEIVE_COMMIT_TARGET,
    color: '#FFA6B0',
  }
)
.addSeriesOverride(
  {
    alias: RECEIVE_COMMIT_POOL_SIZE_TARGET,
    color: '#C4162A',
    fill: 0,
  }
)
