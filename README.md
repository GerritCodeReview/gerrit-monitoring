# Monitoring setup for Gerrit

This project provides a setup for monitoring Gerrit instances. The setup is
based on Prometheus and Grafana running in Kubernetes. In addition, logging will
be provided by Grafana Loki.

The setup is provided as a helm chart. It can be installed using Helm
(This README expects Helm version 3.0 or higher).

The charts used in this setup are the chart provided in the open source and can be
found on GitHub:

- [Prometheus](https://github.com/helm/charts/tree/master/stable/prometheus)
- [Grafana](https://github.com/helm/charts/tree/master/stable/grafana)
- [Loki](https://github.com/grafana/loki/tree/master/production/helm/loki)

This project just provides `values.yaml`-files that are already configured to
work with the `metrics-reporter-prometheus`-plugin of Gerrit to make the setup
easier.

## Dependencies

### Software

- Gerrit \
Gerrit requires the following plugin to be installed:
  - [metrics-reporter-prometheus](https://gerrit.googlesource.com/plugins/metrics-reporter-prometheus/)

- Promtail \
Promtail has to be installed with access to the `logs`-directory in the Gerrit-
site. A configuration-file for Promtail will be provided in this setup. Find
the documentation for Promtail
[here](https://github.com/grafana/loki/blob/master/docs/clients/promtail/README.md)

- Helm \
To install and configure Helm, follow the
[official guide](https://helm.sh/docs/intro/quickstart/#install-helm).

- ytt \
ytt is a templating tool for yaml-files. It is required for some last moment
configuration. Installation instructions can be found
[here](https://k14s.io/#install-from-github-release).

- Pipenv \
Pipenv sets up a virtual python environment and installs required python packages
based on a lock-file, ensuring a deterministic Python environment. Instruction on
how Pipenv can be installed, can be found
[here](https://github.com/pypa/pipenv#installation)

### Infrastructure

- Kubernetes Cluster \
A cluster with at least 3 free CPUs and 4 GB of free memory are required. In
addition persistent storage of about 30 GB will be used.

- Ingress Controller \
The charts currently expect a Nginx ingress controller to be installed in the
cluster.

- Object store \
Loki will store the data chunks in an object store. This store has to be callable
via the S3 API.

## Add dashboards

To have dashboards deployed automatically during installation, export the dashboards
to a JSON-file or create JSON-files describing the dashboards in another way.
Put these dashboards into the `./dashboards`-directory of this repository. During
the installation the dashboards will be added to a configmap and with this
automatically installed to Grafana.

## Configuration

While this project is supposed to provide a specialized and opinionated monitoring
setup, some configuration is highly dependent on the specific installation.
These options have to be configured in the `./config.yaml` before installing and
are listed here:

| option                                             | description                                                                            |
|----------------------------------------------------|----------------------------------------------------------------------------------------|
| `gerritServers`                                    | List of Gerrit servers to scrape. For details refer to section [below](#gerritServers) |
| `namespace`                                        | The namespace the charts are installed to                                              |
| `tls.skipVerify`                                   | Whether to skip TLS certificate verification                                           |
| `tls.caCert`                                       | CA certificate used for TLS certificate verification                                   |
| `monitoring.prometheus.server.host`                | Prometheus server ingress hostname                                                     |
| `monitoring.prometheus.server.username`            | Username for Prometheus                                                                |
| `monitoring.prometheus.server.password`            | Password for Prometheus                                                                |
| `monitoring.prometheus.server.tls.cert`            | TLS certificate                                                                        |
| `monitoring.prometheus.server.tls.key`             | TLS key                                                                                |
| `monitoring.prometheus.alertmanager.slack.apiUrl`  | API URL of the Slack Webhook                                                           |
| `monitoring.prometheus.alertmanager.slack.channel` | Channel to which the alerts should be posted                                           |
| `monitoring.grafana.host`                          | Grafana ingress hostname                                                               |
| `monitoring.grafana.tls.cert`                      | TLS certificate                                                                        |
| `monitoring.grafana.tls.key`                       | TLS key                                                                                |
| `monitoring.grafana.admin.username`                | Username for the admin user                                                            |
| `monitoring.grafana.admin.password`                | Password for the admin user                                                            |
| `monitoring.grafana.ldap.enabled`                  | Whether to enable LDAP                                                                 |
| `monitoring.grafana.ldap.host`                     | Hostname of LDAP server                                                                |
| `monitoring.grafana.ldap.port`                     | Port of LDAP server (Has to be `quoted`!)                                              |
| `monitoring.grafana.ldap.password`                 | Password of LDAP server                                                                |
| `monitoring.grafana.ldap.bind_dn`                  | Bind DN (username) of the LDAP server                                                  |
| `monitoring.grafana.ldap.accountBases`             | List of base DNs to discover accounts (Has to have the format `"['a', 'b']"`)          |
| `monitoring.grafana.ldap.groupBases`               | List of base DNs to discover groups (Has to have the format `"['a', 'b']"`)            |
| `monitoring.grafana.dashboards.editable`           | Whether dashboards can be edited manually in the UI                                    |
| `logging.loki.host`                                | Loki ingress hostname                                                                  |
| `logging.loki.username`                            | Username for Loki                                                                      |
| `logging.loki.password`                            | Password for Loki                                                                      |
| `logging.loki.s3.protocol`                         | Protocol used for communicating with S3                                                |
| `logging.loki.s3.host`                             | Hostname of the S3 object store                                                        |
| `logging.loki.s3.accessToken`                      | The EC2 accessToken used for authentication with S3                                    |
| `logging.loki.s3.secret`                           | The secret associated with the accessToken                                             |
| `logging.loki.s3.bucket`                           | The name of the S3 bucket                                                              |
| `logging.loki.s3.region`                           | The region in which the S3 bucket is hosted                                            |
| `logging.loki.tls.cert`                            | TLS certificate                                                                        |
| `logging.loki.tls.key`                             | TLS key                                                                                |

### `gerritServers`

Two types of Gerrit servers are currently supported, which require different
configuration parameters:

* Kubernetes \
  Gerrit installations running in the same Kubernetes cluster as the monitoring
  setup. Multiple replicas are supported and automatically discovered.

| option                                       | description                                              |
|----------------------------------------------|----------------------------------------------------------|
| `gerritServers.kubernetes.[*].namespace`     | Namespace into which Gerrit was deployed                 |
| `gerritServers.kubernetes.[*].label.name`    | Label name used to select deployments                    |
| `gerritServers.kubernetes.[*].label.value`   | Label value to select deployments                        |
| `gerritServers.kubernetes.[*].containerName` | Name of container in the pod that runs Gerrit            |
| `gerritServers.kubernetes.[*].port`          | Container port to be used when scraping                  |
| `gerritServers.kubernetes.[*].username`      | Username of Gerrit user with 'View Metrics' capabilities |
| `gerritServers.kubernetes.[*].password`      | Password of Gerrit user with 'View Metrics' capabilities |

* Other \
  Gerrit installations with just one replica that can run anywhere, where they
  are reachable via HTTP.

| option                                         | description                                                                        |
|------------------------------------------------|------------------------------------------------------------------------------------|
| `gerritServers.other.[*].host`                 | Hostname (incl. port, if required) of the Gerrit server to monitor                 |
| `gerritServers.other.[*].username`             | Username of Gerrit user with 'View Metrics' capabilities                           |
| `gerritServers.other.[*].password`             | Password of Gerrit user with 'View Metrics' capabilities                           |
| `gerritServers.other.[*].promtail.storagePath` | Path to directory, where Promtail is allowed to save files (e.g. `positions.yaml`) |
| `gerritServers.other.[*].promtail.logPath`     | Path to directory containing the Gerrit logs (e.g. `/var/gerrit/logs`)             |


### Encryption

The configuration file contains secrets. Thus, to be able to share the configuration,
e.g. with the CI-system, it is meant to be encrypted. The encryption is explained
[here](./documentation/config-management.md).

The `gerrit-monitoring.py install`-command will decrypt the file before templating,
if it was encrypted with `sops`.

## Installation

Before using the script, set up a python environment using `pipenv install`.

The installation will use the environment of the current shell. Thus, make sure
that the path for `ytt`, `kubectl`and `helm` are set. Also the `KUBECONFIG`-variable
has to be set to point to the kubeconfig of the target Kubernetes cluster.

This project provides a script to quickly install the monitoring setup. To use
it, run:

```sh
pipenv run python ./gerrit-monitoring.py \
  --config config.yaml \
  install \
  [--output ./dist] \
  [--dryrun] \
  [--update-repo]
```

The command will use the given configuration (`--config`/`-c`) to create the
final files in the directory given by `--output`/`-o` (default `./dist`) and
install/update the Kubernetes resources and charts, if the `--dryrun`/`-d` flag
is not set. If the `--update-repo`-flag is used, the helm repository will be updated
before installing the helm charts. This is for example required, if a chart version
was updated.

## Configure Promtail

Promtail has to be installed with access to the directory containing the Gerrit
logs, e.g. on the same host. The installation as described above will create a
configuration file for Promtail, which can be found in `./dist/promtail.yaml`.
Use it to configure Promtail by using the `-config.file=./dist/promtail.yaml`-
parameter, when starting Promtail. Using the Promtail binary directly this would
result in the following command:

```sh
$PATH_TO_PROMTAIL/promtail \
  -config.file=./dist/promtail.yaml
```

If TLS-verification is activated, the CA-certificate used for verification
(usually the one configured for `tls.caCert`) has to be present in the
directory configured for `promtail.storagePath` in the `config.yaml` and has to
be called `promtail.ca.crt`.

The Promtail configuration provided here expects the logs to be available in
JSON-format. This can be configured by setting `log.jsonLogging = true` in the
`gerrit.config`.

## Uninstallation

To remove the Prometheus chart from the cluster, run

```sh
helm uninstall prometheus --namespace $NAMESPACE
helm uninstall loki --namespace $NAMESPACE
helm uninstall grafana --namespace $NAMESPACE
kubectl delete -f ./dist/configuration
```

To also release the volumes, run

```sh
kubectl delete -f ./dist/storage
```

NOTE: Doing so, all data, which was not backed up will be lost!

Remove the namespace:

```sh
kubectl delete -f ./dist/namespace.yaml
```

The `./gerrit-monitoring.py uninstall`-script will automatically remove the
charts installed in the configured namespace and delete the namespace as well:

```sh
pipenv run python ./gerrit-monitoring.py \
  --config config.yaml \
  uninstall
```
