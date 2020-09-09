{
  dashboards: {
    editable: false,
    schemaVersion: 22,
    timeFrom: 'now-24h',
    timeTo: 'now',
    refresh: '1m',
  },
  datasource: if std.extVar('publish') then '${DS_PROMETHEUS}' else 'Prometheus',
}
