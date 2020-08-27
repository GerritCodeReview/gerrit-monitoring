from grafanalib.core import (
    Templating,
    Template,
)

gerrit_instances = Templating(
    [
        Template(
            name="instance",
            dataSource="Prometheus",
            label="Gerrit Instance",
            query="label_values(git_upload_pack_phase_writing_total, instance)",
        ),
        Template(
            name="replica",
            dataSource="Prometheus",
            label="Gerrit Replica",
            query='label_values(git_upload_pack_phase_writing_total{instance="$instance"}, replica)',
        ),
    ]
)
