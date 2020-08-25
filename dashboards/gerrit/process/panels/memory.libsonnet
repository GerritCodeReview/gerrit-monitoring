local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local graphPanel = grafana.graphPanel;
local prometheus = grafana.prometheus;

local lineGraph = import '../../../globals/line-graph.libsonnet';

lineGraph.new(
  title='Memory',
  formatY1='decbytes',
  labelY1='Memory Consumption',
)
.addTarget(
  prometheus.target(
    'proc_jvm_memory_heap_committed{instance="$instance",replica="$replica"}',
    legendFormat='committed heap'
  )
)
.addTarget(
  prometheus.target(
    'proc_jvm_memory_heap_used{instance="$instance",replica="$replica"}',
    legendFormat='used heap'
  )
)
.addTarget(
  prometheus.target(
    'jgit_block_cache_cache_used{instance="$instance",replica="$replica"}',
    legendFormat='JGit block cache'
  )
)
.addTarget(
  prometheus.target(
    'proc_jvm_memory_non_heap_used{instance="$instance",replica="$replica"}',
    legendFormat='used non-heap'
  )
)
