local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

local lineGraph = import '../../../globals/line-graph.libsonnet';

local BATCH_TARGET = 'batch';
local INTERACTIVE_TARGET = 'interactive';

lineGraph.new(
  title='INDEX queue',
  labelY1='Tasks',
)
.addTarget(
  prometheus.target(
    'queue_index_batch_scheduled_tasks{instance="$instance",replica="$replica"}',
    legendFormat=BATCH_TARGET,
  )
)
.addTarget(
  prometheus.target(
    'queue_index_interactive_scheduled_tasks{instance="$instance",replica="$replica"}',
    legendFormat=INTERACTIVE_TARGET,
  )
)
.addSeriesOverride(
  {
    alias: BATCH_TARGET,
    color: '#FFB357',
  }
)
.addSeriesOverride(
  {
    alias: INTERACTIVE_TARGET,
    color: '#C0D8FF',
  }
)
