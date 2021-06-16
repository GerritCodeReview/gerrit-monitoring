local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;
local gauge = grafana.barGaugePanel;

local defaults = import '../../../globals/defaults.libsonnet';

gauge.new(
  title='Live Threads',
  datasource=defaults.datasource,
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
