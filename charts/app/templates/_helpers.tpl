{{- define "app.name" -}}
{{- required "platform.name é preenchido pela esteira" .Values.platform.name -}}
{{- end -}}

{{- define "app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "app.name" . }}
{{- end -}}

{{- define "app.labels" -}}
{{ include "app.selectorLabels" . }}
app.kubernetes.io/part-of: {{ .Values.platform.product }}
app.kubernetes.io/version: {{ .Values.image.tag | quote }}
app.kubernetes.io/managed-by: plataforma
plataforma.acme/sigla: {{ .Values.platform.sigla }}
plataforma.acme/ambiente: {{ .Values.platform.environment }}
{{- end -}}
