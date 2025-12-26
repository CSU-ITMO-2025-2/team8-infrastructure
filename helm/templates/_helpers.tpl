{{/*
Expand the name of the chart.
*/}}
{{- define "team8-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "team8-app.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "team8-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Worker name helpers build on the base app helpers to keep naming consistent.
*/}}
{{- define "demo-worker.name" -}}
{{- printf "%s-worker" (include "team8-app.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "demo-worker.fullname" -}}
{{- printf "%s-worker" (include "team8-app.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "demo-worker.chart" -}}
{{- include "team8-app.chart" . -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "team8-app.labels" -}}
helm.sh/chart: {{ include "team8-app.chart" . }}
sidecar.istio.io/inject: "true"
{{ include "team8-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "team8-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "team8-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Worker-specific labels
*/}}
{{- define "demo-worker.labels" -}}
helm.sh/chart: {{ include "demo-worker.chart" . }}
{{ include "demo-worker.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Worker selector labels
*/}}
{{- define "demo-worker.selectorLabels" -}}
app.kubernetes.io/name: {{ include "demo-worker.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "team8-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "team8-app.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
Service account name for worker resources
*/}}
{{- define "demo-worker.serviceAccountName" -}}
{{- include "team8-app.serviceAccountName" . -}}
{{- end -}}
