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

resource "kubernetes_ingress_v1" "example" {
  wait_for_load_balancer = false
  metadata {
    name      = "argocd-server-ingress"
    namespace = kubernetes_namespace.argocd.metadata[0].name

    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }
  spec {
    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "argo-cd-argocd-server"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}