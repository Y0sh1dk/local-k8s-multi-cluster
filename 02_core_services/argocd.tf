resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.argocd_namespace
  }
}

resource "helm_release" "argocd" {
  namespace        = kubernetes_namespace.argocd.metadata[0].name
  create_namespace = false
  name             = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.argocd_chart_version
  timeout          = var.timeout_seconds

  set_sensitive {
    name  = "configs.secret.argocdServerAdminPassword"
    value = var.argocd_admin_password == "" ? "" : bcrypt(var.argocd_admin_password)
  }

  set {
    name  = "configs.params.server\\.insecure"
    value = var.argocd_insecure
  }

  # set {
  #   name  = "configs.params.server\\.rootPath"
  #   value = "/argo-cd"
  # }

  # set {
  #   name  = "configs.params.server\\.basehref"
  #   value = "/argo-cd"
  # }
}
