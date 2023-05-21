resource "helm_release" "linkerd-multicluster" {
  namespace        = var.namespace
  create_namespace = var.create_namespace

  name       = "linkerd-multicluster"
  repository = "https://helm.linkerd.io/stable"
  chart      = "linkerd-multicluster"
  version    = "30.7.3"
  timeout    = var.timeout

  set {
    name  = "gateway.serviceType"
    value = "NodePort"
  }

}
