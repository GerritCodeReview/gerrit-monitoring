local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

local lineGraph = import '../../../globals/line-graph.libsonnet';

lineGraph.new(
  title='REST API request rate',
  labelY1='Requests/Second',
  formatY1='reqps',
)
.addTarget(
  prometheus.target(
    'rate(http_server_rest_api_count_total_total{instance="$instance",replica="$replica"}[5m])',
    legendFormat='REST API request rate',
  )
)
