resource "helm_release" "kube_prometheus" {
  namespace        = var.namespace
  create_namespace = var.create_namespace

  name       = "kube-prometheus"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "kube-prometheus"
  version    = "8.13.0"
  timeout    = var.timeout

  set {
    name  = "prometheus.thanos.create"
    value = "true"
  }

  set {
    name  = "operator.service.type"
    value = "ClusterIP"
  }

  set {
    name  = "prometheus.service.type"
    value = "ClusterIP"
  }

  set {
    name  = "alertmanager.service.type"
    value = "ClusterIP"
  }

  set {
    name  = "prometheus.thanos.service.type"
    value = "ClusterIP"
  }

  set {
    name  = "prometheus.externalLabels.cluster"
    value = var.cluster_label
  }

}
