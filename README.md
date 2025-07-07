# helm-act

## Rootless Defaults

If `.Values.image.rootless: true`, then the following will occur. In case you use `.Values.image.fullOverride`, check that this works in your image:

- If `.Values.provisioning.enabled: true`, then uses the rootless Gitea image, must match helm-Gitea.

## Parameters

### Gitea Actions

| Name                                      | Description                                                                                                                                 | Value                          |
| ----------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------ |
| `enabled`                                 | Create an act runner StatefulSet.                                                                                                           | `false`                        |
| `init.image.repository`                   | The image used for the init containers                                                                                                      | `busybox`                      |
| `init.image.tag`                          | The image tag used for the init containers                                                                                                  | `1.37.0`                       |
| `statefulset.annotations`                 | Act runner annotations                                                                                                                      | `{}`                           |
| `statefulset.labels`                      | Act runner labels                                                                                                                           | `{}`                           |
| `statefulset.resources`                   | Act runner resources                                                                                                                        | `{}`                           |
| `statefulset.nodeSelector`                | NodeSelector for the statefulset                                                                                                            | `{}`                           |
| `statefulset.tolerations`                 | Tolerations for the statefulset                                                                                                             | `[]`                           |
| `statefulset.affinity`                    | Affinity for the statefulset                                                                                                                | `{}`                           |
| `statefulset.extraVolumes`                | Extra volumes for the statefulset                                                                                                           | `[]`                           |
| `statefulset.actRunner.repository`        | The Gitea act runner image                                                                                                                  | `gitea/act_runner`             |
| `statefulset.actRunner.tag`               | The Gitea act runner tag                                                                                                                    | `0.2.11`                       |
| `statefulset.actRunner.pullPolicy`        | The Gitea act runner pullPolicy                                                                                                             | `IfNotPresent`                 |
| `statefulset.actRunner.extraVolumeMounts` | Allows mounting extra volumes in the act runner container                                                                                   | `[]`                           |
| `statefulset.actRunner.config`            | Act runner custom configuration. See [Act Runner documentation](https://docs.gitea.com/usage/actions/act-runner#configuration) for details. | `Too complex. See values.yaml` |
| `statefulset.dind.repository`             | The Docker-in-Docker image                                                                                                                  | `docker`                       |
| `statefulset.dind.tag`                    | The Docker-in-Docker image tag                                                                                                              | `25.0.2-dind`                  |
| `statefulset.dind.pullPolicy`             | The Docker-in-Docker pullPolicy                                                                                                             | `IfNotPresent`                 |
| `statefulset.dind.extraVolumeMounts`      | Allows mounting extra volumes in the Docker-in-Docker container                                                                             | `[]`                           |
| `statefulset.dind.extraEnvs`              | Allows adding custom environment variables, such as `DOCKER_IPTABLES_LEGACY`                                                                | `[]`                           |
| `statefulset.persistence.size`            | Size for persistence to store act runner data                                                                                               | `1Gi`                          |
| `provisioning.enabled`                    | Create a job that will create and save the token in a Kubernetes Secret                                                                     | `false`                        |
| `provisioning.annotations`                | Job's annotations                                                                                                                           | `{}`                           |
| `provisioning.labels`                     | Job's labels                                                                                                                                | `{}`                           |
| `provisioning.resources`                  | Job's resources                                                                                                                             | `{}`                           |
| `provisioning.nodeSelector`               | NodeSelector for the job                                                                                                                    | `{}`                           |
| `provisioning.tolerations`                | Tolerations for the job                                                                                                                     | `[]`                           |
| `provisioning.affinity`                   | Affinity for the job                                                                                                                        | `{}`                           |
| `provisioning.ttlSecondsAfterFinished`    | ttl for the job after finished in order to allow helm to properly recognize that the job completed                                          | `300`                          |
| `provisioning.publish.repository`         | The image that can create the secret via kubectl                                                                                            | `bitnami/kubectl`              |
| `provisioning.publish.tag`                | The publish image tag that can create the secret                                                                                            | `1.29.0`                       |
| `provisioning.publish.pullPolicy`         | The publish image pullPolicy that can create the secret                                                                                     | `IfNotPresent`                 |
| `existingSecret`                          | Secret that contains the token                                                                                                              | `""`                           |
| `existingSecretKey`                       | Secret key                                                                                                                                  | `""`                           |
| `giteaRootURL`                            | URL the act_runner registers and connect with                                                                                               | `""`                           |

### Persistence

| Name                                              | Description                                                               | Value                  |
| ------------------------------------------------- | ------------------------------------------------------------------------- | ---------------------- |
| `persistence.enabled`                             | Enable persistent storage                                                 | `true`                 |
| `persistence.create`                              | Whether to create the persistentVolumeClaim for shared storage            | `true`                 |
| `persistence.mount`                               | Whether the persistentVolumeClaim should be mounted (even if not created) | `true`                 |
| `persistence.claimName`                           | Use an existing claim to store repository information                     | `gitea-shared-storage` |
| `persistence.size`                                | Size for persistence to store repo information                            | `10Gi`                 |
| `persistence.accessModes`                         | AccessMode for persistence                                                | `["ReadWriteOnce"]`    |
| `persistence.labels`                              | Labels for the persistence volume claim to be created                     | `{}`                   |
| `persistence.annotations.helm.sh/resource-policy` | Resource policy for the persistence volume claim                          | `keep`                 |
| `persistence.storageClass`                        | Name of the storage class to use                                          | `nil`                  |
| `persistence.subPath`                             | Subdirectory of the volume to mount at                                    | `nil`                  |
| `persistence.volumeName`                          | Name of persistent volume in PVC                                          | `""`                   |

### Image

| Name                 | Description                                                                                                                                                      | Value              |
| -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------ |
| `image.registry`     | image registry, e.g. gcr.io,docker.io                                                                                                                            | `docker.gitea.com` |
| `image.repository`   | Image to start for this pod                                                                                                                                      | `gitea`            |
| `image.tag`          | Visit: [Image tag](https://hub.docker.com/r/gitea/gitea/tags?page=1&ordering=last_updated). Defaults to `appVersion` within Chart.yaml.                          | `""`               |
| `image.digest`       | Image digest. Allows to pin the given image tag. Useful for having control over mutable tags like `latest`                                                       | `""`               |
| `image.pullPolicy`   | Image pull policy                                                                                                                                                | `IfNotPresent`     |
| `image.rootless`     | Wether or not to pull the rootless version of Gitea, only works on Gitea 1.14.x or higher                                                                        | `true`             |
| `image.fullOverride` | Completely overrides the image registry, path/image, tag and digest. **Adjust `image.rootless` accordingly and review [Rootless defaults](#rootless-defaults).** | `""`               |

### Global

| Name                   | Description                    | Value |
| ---------------------- | ------------------------------ | ----- |
| `global.imageRegistry` | global image registry override | `""`  |
| `global.storageClass`  | global storage class override  | `""`  |
