local grafana = import '../../../vendor/grafonnet/grafana.libsonnet';
local template = grafana.template;

local defaults = import '../../globals/defaults.libsonnet';

{
  instance: template.new(
    name='instance',
    datasource=defaults.datasource,
    query='label_values(git_upload_pack_phase_writing_total, instance)',
    label='Gerrit Instance',
    refresh='load',
  ),
  replica: template.new(
    name='replica',
    datasource=defaults.datasource,
    query='label_values(git_upload_pack_phase_writing_total{instance="$instance"}, replica)',
    label='Replica',
    refresh='time',
  ),
}
