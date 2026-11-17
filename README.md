# platform-helm-charts

Charts da plataforma. O serviço não tem chart próprio: ele traz só os values em
`deploy/`, e a esteira renderiza o chart `app` com eles e grava os manifestos no repo GitOps.

## charts/app

| Quem preenche | Campos |
|---|---|
| Esteira (`--set`) | `platform.name` (nome do repo), `platform.sigla`, `platform.product`, `platform.environment`, `image.repository`, `image.tag` |
| Time do serviço (`deploy/values*.yaml`) | `replicas`, `port`, `resources`, `env`, `probes`, `route` |

O `values.schema.json` recusa qualquer campo fora dessa lista (por exemplo `namespace`),
tag `latest` e réplicas fora de 1–10. O erro aparece na esteira, antes de chegar ao cluster.

Gera: `ServiceAccount` (sem token montado), `Deployment` (sem root, sem privilégios,
probes de startup, liveness e readiness), `Service`, `PodDisruptionBudget` (com mais de
uma réplica) e `Route` do OpenShift (com `route.enabled`). O namespace não fica no
manifesto: quem define é o Argo CD, pelo produto e ambiente.

Identidade no runtime: o chart injeta `OTEL_SERVICE_NAME` e `OTEL_RESOURCE_ATTRIBUTES`
(padrão OpenTelemetry, vale para qualquer linguagem). O que é específico da linguagem vai
nos values do golden path, com template:

```yaml
env:
  SPRING_APPLICATION_NAME: "{{ .Values.platform.name }}"
```

## Versões

Tags semânticas (`v1.0.0`) e a tag de major (`v1`) que a esteira usa. Mudança que quebra
values existentes vira `v2`.

## POC × banco

| POC | Banco |
|---|---|
| A esteira faz checkout deste repo na tag | Chart publicado como OCI no Quay ou no Nexus |
| `Route` com TLS edge | Mesmo modelo; o certificado e o domínio `*.apps` são do cluster |
