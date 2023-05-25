resource "helm_release" "thanos" {
  namespace        = var.namespace
  create_namespace = var.create_namespace

  name       = "thanos"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "thanos"
  version    = "12.6.2"
  timeout    = var.timeout

  set {
    name  = "query.stores"
    value = "{${join(",", var.query_stores)}}"
  }

}
