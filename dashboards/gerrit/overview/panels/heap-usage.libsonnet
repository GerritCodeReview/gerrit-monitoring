local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;
local gauge = grafana.gaugePanel;

gauge.new(
  title='Heap Memory Usage',
  datasource='Prometheus',
)
.addTarget(
  target=prometheus.target(
    '(proc_jvm_memory_heap_used{instance="$instance",replica="$replica"}/proc_jvm_memory_heap_committed{instance="$instance",replica="$replica"})*100',
    legendFormat=' ',
    intervalFactor=1,
    instant=true,
  ),
)
.addThresholds([
  {
    color: 'green',
    value: null
  },
  {
    color: 'orange',
    value: 60
  },
  {
    color: 'red',
    value: 90
  }
])
