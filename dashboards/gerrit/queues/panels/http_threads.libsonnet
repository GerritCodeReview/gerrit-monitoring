local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

local lineGraph = import '../../../globals/line-graph.libsonnet';
local yAxis = import '../../../globals/yaxis.libsonnet';

local ACTIVE_THREADS_TARGET = 'active threads';
local RESERVED_THREADS_TARGET = 'reserved threads';
local MAX_POOL_SIZE_TARGET = 'max pool size';
local POOL_SIZE_TARGET = 'pool size';

lineGraph.new(
  title='HTTP threads',
  yAxis1=yAxis.new(label='Threads'),
)
.addTarget(
  prometheus.target(
    'http_server_jetty_threadpool_active_threads{instance="$instance",replica="$replica"}',
    legendFormat=ACTIVE_THREADS_TARGET,
  )
)
.addTarget(
  prometheus.target(
    'http_server_jetty_threadpool_reserved_threads{instance="$instance",replica="$replica"}',
    legendFormat=RESERVED_THREADS_TARGET,
  )
)
.addTarget(
  prometheus.target(
    'http_server_jetty_threadpool_max_pool_size{instance="$instance",replica="$replica"}',
    legendFormat=MAX_POOL_SIZE_TARGET,
  )
)
.addTarget(
  prometheus.target(
    'http_server_jetty_threadpool_pool_size{instance="$instance",replica="$replica"}',
    legendFormat= POOL_SIZE_TARGET,
  )
)
.addSeriesOverride(
  {
    alias: ACTIVE_THREADS_TARGET,
    color: '#FFB357',
  }
)
.addSeriesOverride(
  {
    alias: RESERVED_THREADS_TARGET,
    color: '#56A64B',
    fill: 0,
  }
)
.addSeriesOverride(
  {
    alias: MAX_POOL_SIZE_TARGET,
    color: '#FA6400',
    fill: 0,
  }
)
.addSeriesOverride(
  {
    alias:  POOL_SIZE_TARGET,
    color: '#1F60C4',
    fill: 0,
  }
)
