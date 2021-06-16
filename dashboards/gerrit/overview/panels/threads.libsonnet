local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;
local gauge = grafana.barGaugePanel;

gauge.new(
  title='Live Threads',
  thresholds=[{
    color: 'green',
    value: null,
  }],
)
.addTarget(
  target=prometheus.target(
    'proc_jvm_thread_num_daemon_live{instance="$instance",replica="$replica"}',
    legendFormat='current (daemon)',
    intervalFactor=1,
    instant=true,
  ),
)
.addTarget(
  target=prometheus.target(
    'proc_jvm_thread_num_live{instance="$instance",replica="$replica"}',
    legendFormat='current (total)',
    intervalFactor=1,
    instant=true,
  ),
)
.addTarget(
  target=prometheus.target(
    'proc_jvm_thread_num_peak_live{instance="$instance",replica="$replica"}',
    legendFormat='peak',
    intervalFactor=1,
    instant=true,
  ),
)
