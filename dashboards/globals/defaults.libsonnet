{
  dashboards: {
    editable: false,
    schemaVersion: 22,
    timeFrom: 'now-24h',
    timeTo: 'now',
    refresh: '1m',
  },
  panels: {
    width: 12,
    height: 11,
  },
  datasource: if std.extVar('publish') then '${DS_PROMETHEUS}' else 'Prometheus',
}
