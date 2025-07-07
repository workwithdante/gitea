{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}

{{- define "gitea.actions.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "gitea.actions.fullname" -}}
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
Create a default worker name.
*/}}
{{- define "gitea.actions.workername" -}}
{{- printf "%s-%s" .global.Release.Name .worker | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "gitea.actions.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create image name and tag used by the deployment.
*/}}
{{- define "gitea.actions.image" -}}
{{- $fullOverride := .Values.image.fullOverride | default "" -}}
{{- $registry := .Values.global.imageRegistry | default .Values.image.registry -}}
{{- $repository := .Values.image.repository -}}
{{- $separator := ":" -}}
{{- $tag := .Values.image.tag | default .Chart.AppVersion | toString -}}
{{- $rootless := ternary "-rootless" "" (.Values.image.rootless) -}}
{{- $digest := "" -}}
{{- if .Values.image.digest }}
    {{- $digest = (printf "@%s" (.Values.image.digest | toString)) -}}
{{- end -}}
{{- if $fullOverride }}
    {{- printf "%s" $fullOverride -}}
{{- else if $registry }}
    {{- printf "%s/%s%s%s%s%s" $registry $repository $separator $tag $rootless $digest -}}
{{- else -}}
    {{- printf "%s%s%s%s%s" $repository $separator $tag $rootless $digest -}}
{{- end -}}
{{- end -}}

{{/*
Storage Class
*/}}
{{- define "gitea.actions.persistence.storageClass" -}}
{{- $storageClass :=  (tpl ( default "" .Values.persistence.storageClass) .) | default (tpl ( default "" .Values.global.storageClass) .) }}
{{- if $storageClass }}
storageClassName: {{ $storageClass | quote }}
{{- end }}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "gitea.actions.labels" -}}
helm.sh/chart: {{ include "gitea.actions.chart" . }}
app: {{ include "gitea.actions.name" . }}
{{ include "gitea.actions.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.image.tag | default .Chart.AppVersion | quote }}
version: {{ .Values.image.tag | default .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "gitea.actions.labels.actRunner" -}}
helm.sh/chart: {{ include "gitea.actions.chart" . }}
app: {{ include "gitea.actions.name" . }}-act-runner
{{ include "gitea.actions.selectorLabels.actRunner" . }}
app.kubernetes.io/version: {{ .Values.image.tag | default .Chart.AppVersion | quote }}
version: {{ .Values.image.tag | default .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "gitea.actions.selectorLabels" -}}
app.kubernetes.io/name: {{ include "gitea.actions.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "gitea.actions.selectorLabels.actRunner" -}}
app.kubernetes.io/name: {{ include "gitea.actions.name" . }}-act-runner
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "gitea.actions.local_root_url" -}}
  {{- .Values.giteaRootURL -}}
{{- end -}}

{{/*
Parse the http url to hostname + port separated by space for the nc command
*/}}
{{- define "gitea.actions.nc" -}}
{{- $url := include "gitea.actions.local_root_url" . | urlParse -}}
{{- $host := get $url "host" -}}
{{- $scheme := get $url "scheme" -}}
{{- $port := "80" -}}
{{- if contains ":" $host -}}
    {{- $hostAndPort := regexSplit ":" $host 2 -}}
    {{- $host = index $hostAndPort 0 -}}
    {{- $port = index $hostAndPort 1 -}}
{{- else if eq $scheme "https" -}}
    {{- $port = "443" -}}
{{- else if eq $scheme "http" -}}
    {{- $port = "80" -}}
{{- end -}}
{{- printf "%s %s" $host $port -}}
{{- end -}}
