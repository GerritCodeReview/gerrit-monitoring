local grafana = import '../../../../vendor/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

{
  new(
    cache
  )::
    prometheus.target(
      std.format('100-caches_memory_hit_ratio_%s{instance="$instance",replica="$replica"}', cache),
      legendFormat=cache,
    )
}
