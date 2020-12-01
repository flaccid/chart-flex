# chart-flex

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

An example of a flexible Helm chart that could help developers easily deploy their software using the one boilerplate chart for different types of workloads.

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
- tests with terratest
- make jobs an array like cronjobs without boolean toggle

## Prerequisites

- Kubernetes >= 1.10.0
- Helm >= 3.0.0

## Usage

You can use the chart directly and override the image etc. though typically you would make a copy and edit.

### Values Reference

The following table lists the configurable parameters of the flex chart and the default values.

| Parameter           | Description                          | Default         |
| ------------------- | -------------------------------------| --------------- |
| `affinity`              |                                    | `{}`            |
| `autoscaling.enabled` |                                    | `false`         |
| `autoscaling.minReplicas` |                                | `1`             |
| `autoscaling/maxReplicas` |                                | `100`           |
| `autoscaling.targetCPUUtilizationPercentage` |             | `80`            |
| `autoscaling.targetMemoryUtilizationPercentage` |          |                 |
| `cronjob.enabled`     |                                    | `false`         |
| `daemonset.enabled`   |                                    | `false`         |
| `deployment.enabled`  |                                    | `true`          |
| `fullnameOverride`    |                                    |                 |
| `global.environment`  |                                    | `[]`            |
| `imagePullSecrets`    |                                    | `[]`            |
| `image.pullPolicy`    |                                    | `IfNotPresent`  |
| `image.repository`    |                                    | `nginx`         |
| `image.tag`           |                                    | `stable`        |
| `ingress.enabled`     |                                    | `false`         |
| `ingress.annotations` |                                    | `{}`            |
| `ingress.hosts`       |                                    | `[{ host: chart-example.local, paths: {  } }]` |
| `ingress.tls`         |                                    | `[]`            |
| `job.enabled`         |                                    | `false`         |
| `job.restartPolicy`   |                                    | `OnFailure`     |
| `nameOverride`        |                                    |                 |
| `nodeSelector`        |                                    | `{}`            |
| `podAnnotations`      |                                    | `{}`            |
| `podSecurityContext`  |                                    | `{}`            |
| `replicaCount`        |                                    | `1`             |
| `replicaset.enabled`  |                                    | `false`         |
| `resources`           |                                    | `{}`            |
| `securityContext`     |                                    | `{}`            |
| `serviceAccount.annotations` | Annotations to add to the service account | `{}` |
| `serviceAccount.create` | Specifies whether a service account should be created | `true` |
| `serviceAccount.name` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template | |
| `service.port`        |                                    | `80`            |
| `service.type`        |                                    | `ClusterIP`     |
| `statefulset.enabled` |                                    | `false`         |
| `tolerations`         |                                    | `[]`            |

### Quick Guide

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

#### Installation

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

#### Testing

Testing after creation of a release:

`helm test flex`

#### Upgrading

Upgrade the chart, with values file:

```
helm upgrade flex . \
  -f helm-values.local.yaml
```

#### Uninstallation

Completely remove the chart:

`helm uninstall flex`

### Workload Type Switching

#### `Deployment`

This is the default workload type. To disable it, set the `deployment` value to `false`.

#### `ReplicaSet`

Set `replicaset.enabled` to `true`.

#### `StatefulSet`

Set `statefulset.enabled` to `true`.

#### `DaemonSet`

Set `daemonset.enabled` to `true`.

#### `Job`

This is adapted from https://github.com/cetic/helm-job.

Disable the deployment, setup a job as required, e.g.:

```
deployment:
  enabled: false
job:
  enabled: true
image:
  repository: "hello-world"
  tag: "latest"
```

#### `CronJob`

This is adapated from https://github.com/bambash/helm-cronjobs.

Disable the deployment and set one or more cron jobs as required, e.g.:

```
deployment:
  enabled: false
cronjobs:
  - name: 'hello-world'
    image:
      repository: hello-world
      tag: latest
      imagePullPolicy: Always
    schedule: "*/5 * * * *"
    failedJobsHistoryLimit: 5
    successfulJobsHistoryLimit: 100
    concurrencyPolicy: Allow
    restartPolicy: OnFailure
```

## Contributing

Please feel free to contribute by making a [pull request](https://github.com/flaccid/chart-flex/pulls).

## License

- Author: Chris Fordham (<chris@fordham.id.au>)

```text
Copyright 2020, Chris Fordham

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
