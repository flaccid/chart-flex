# chart-flex
An example of a flexible Helm chart which could help developers

## Overview

An attempt to cover the main workload resources in once chart:

- `Deployment`
- `ReplicaSet`
- `StatefulSet`
- `DaemonSet`
- `Job`
- `CronJob`

TODO:
- look at `ReplicationController`
- make the `NOTES.txt` and `_helpers.tpl` work nicely based on chosen workload type(s)

## Usage

You can use the chart directly and override the image etc. though typically you would make a copy and edit.

<values table>

Validate the chart:

`helm lint .`

Dry run and print out rendered YAML:

`helm install --dry-run --debug flex .`

Dry run and print out rendered YAML with merged values file:

```
helm install \
  --dry-run \
  --debug \
  -f helm-values.local.yaml \
    flex .
```

Install the chart:

`helm install flex .`

Or, with some different values:

```
helm install flex \
  --set image.tag="latest" \
  --set service.type="LoadBalancer" \
    ,
```

Or, the same but with a custom values from a file:

```
helm install flex \
  -f helm-values.local.yaml \
    .
```

Upgrade the chart, with values file:

```
helm upgrade flex . \
  -f helm-values.local.yaml
```

Testing after deployment:

`helm test flex`

Completely remove the chart:

`helm uninstall flex`

### `Deployment`

This is the default workload type. To disable it, set the `deployment` value to false.

### `ReplicaSet`

Set `replicaset.enabled` to `true`.

### `StatefulSet`

Set `statefulset.enabled` to `true`.

### `DaemonSet`

Set `daemonset.enabled` to `true`.

### `Job`

Set `job.enabled` to `true`.

### `CronJob`

Set `cronjob.enabled` to `true`.
