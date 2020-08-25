{
  __inputs: [
    {
      name: 'DS_PROMETHEUS',
      label: 'Prometheus',
      description: '',
      type: 'datasource',
      pluginId: 'prometheus',
      pluginName: 'Prometheus',
    },
  ],
  __requires: [
    {
      type: 'grafana',
      id: 'grafana',
      name: 'Grafana',
      version: '7.1.5',
    },
    {
      type: 'panel',
      id: 'graph',
      name: 'Graph',
      version: '',
    },
    {
      type: 'datasource',
      id: 'prometheus',
      name: 'Prometheus',
      version: '1.0.0',
    },
  ],
}
