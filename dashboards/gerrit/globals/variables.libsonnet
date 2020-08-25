local grafana = import '../../../vendor/grafonnet/grafana.libsonnet';
local template = grafana.template;

{
  instance: template.new(
    name='instance',
    datasource='Prometheus',
    query='label_values(git_upload_pack_phase_writing_total, instance)',
    label='Gerrit Instance',
    refresh='load',
  ),
  replica: template.new(
    name='replica',
    datasource='Prometheus',
    query='label_values(git_upload_pack_phase_writing_total{instance="$instance"}, replica)',
    label='Replica',
    refresh='time',
  ),
}
