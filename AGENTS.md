# AGENTS.md

## What this is
A single Helm chart (`flex`) that doubles as a published Helm repo (GitHub Pages at https://flaccid.github.io/chart-flex/). One workload type renders at a time, toggled by boolean values in `values.yaml`: `deployment.enabled` (default `true`), `daemonset`, `statefulset`, `replicaset`, `job`, `cronjob`. ServiceAccount, Service, HPA, and Ingress also render from their own values blocks.

## Verify / lint
- `helm lint .`
- `helm template flex . --set deployment.enabled=false --set statefulset.enabled=true --set service.enabled=true ...` — when editing values or a workload template, render with the affected toggle changed; the defaults only exercise the Deployment path.

## Release flow (required for any template/values change)
1. Bump `version:` in `Chart.yaml` (semver).
2. `helm package .` → creates `flex-<version>.tgz`.
3. Remove the old `flex-*.tgz` from the repo root.
4. `helm repo index --url https://flaccid.github.io/chart-flex/ .` to regenerate `index.yaml`.
5. Commit everything (source, tgz, index.yaml), tag `vX.Y.Z`, push main + tag.

## Gotchas
- Ingress is `networking.k8s.io/v1` only; the chart requires Kubernetes >= 1.19. `ingress.className` renders `ingressClassName` when set. The backend always points at the Service, so `service.enabled` must be true for a working ingress (the Service also renders when `statefulset.enabled`).
- `questions.yml` configures the Rancher catalog UI. Array/list subquestions (e.g. `ingress.hosts`) cannot be exposed from the Rancher UI (rancher/rancher#13952) — keep those blocks commented out.
- `.gitignore` ignores `helm-values.*.yaml`; don't commit local values files. `helm-values.dev.yaml` is a committed empty placeholder used by the `make helm-*` targets.
- `make help` lists targets (`helm-validate` = lint, `helm-render` = dry-run, `helm-package`, `helm-index`).
- The packaged tgz includes stray repo files (`index.yaml`, `helm-values.dev.yaml`, `questions.yml`) because `.helmignore` only excludes `*.tgz`, `.gitignore`, `.banner`, `Makefile`. Pre-existing behavior; don't "clean it up" unless intentional.
