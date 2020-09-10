local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

local lineGraph = import '../../../globals/line-graph.libsonnet';
local yAxis = import '../../../globals/yaxis.libsonnet';

local BATCH_THREADS_TARGET = 'batch threads';
local BATCH_POOL_SIZE_TARGET = 'batch pool size';
local INTERACTIVE_THREADS_TARGET = 'interactive threads';
local INTERACTIVE_POOL_SIZE_TARGET = 'interactive pool size';

lineGraph.new(
  title='INDEX threads',
  yAxis1=yAxis.new(label='Threads'),
)
.addTarget(
  prometheus.target(
    'queue_index_batch_active_threads{instance="$instance",replica="$replica"}',
    legendFormat=BATCH_THREADS_TARGET,
  )
)
.addTarget(
  prometheus.target(
    'queue_index_batch_pool_size{instance="$instance",replica="$replica"}',
    legendFormat=BATCH_POOL_SIZE_TARGET,
  )
)
.addTarget(
  prometheus.target(
    'queue_index_interactive_active_threads{instance="$instance",replica="$replica"}',
    legendFormat=INTERACTIVE_THREADS_TARGET,
  )
)
.addTarget(
  prometheus.target(
    'queue_index_interactive_pool_size{instance="$instance",replica="$replica"}',
    legendFormat=INTERACTIVE_POOL_SIZE_TARGET,
  )
)
.addSeriesOverride(
  {
    alias: BATCH_THREADS_TARGET,
    color: '#FFB357',
  }
)
.addSeriesOverride(
  {
    alias: BATCH_POOL_SIZE_TARGET,
    color: '#FA6400',
    fill: 0,
  }
)
.addSeriesOverride(
  {
    alias: INTERACTIVE_THREADS_TARGET,
    color: '#C0D8FF',
  }
)
.addSeriesOverride(
  {
    alias: INTERACTIVE_POOL_SIZE_TARGET,
    color: '#1F60C4',
    fill: 0,
  }
)
