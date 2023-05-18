
resource "kubernetes_ingress_v1" "argocd" {
  wait_for_load_balancer = false
  metadata {
    name      = "argocd-server-ingress"
    namespace = data.terraform_remote_state.tf_02_core_services.outputs.argocd_config.chart_metadata[0].namespace

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
