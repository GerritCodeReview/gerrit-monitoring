local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

local lineGraph = import '../../../globals/line-graph.libsonnet';

local HTTP_TARGET = 'http';

lineGraph.new(
  title='HTTP queue',
  labelY1='Tasks',
)
.addTarget(
  prometheus.target(
    'http_server_jetty_threadpool_queue_size{instance="$instance",replica="$replica"}',
    legendFormat=HTTP_TARGET,
  )
)
.addSeriesOverride(
  {
    alias: HTTP_TARGET,
    color: '#FFB357',
  }
)
