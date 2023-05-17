resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = var.ingress_nginx_namespace
  }
}

resource "helm_release" "ingress_nginx" {
  namespace        = kubernetes_namespace.ingress_nginx.metadata[0].name
  create_namespace = false
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  # version          = "0.17.1"
  timeout = var.timeout_seconds

  set {
    name  = "controller.nodeSelector.ingress-ready"
    type  = "string"
    value = "true"
  }

  set {
    name  = "controller.hostPort.enabled"
    value = "true"
  }

  set {
    name  = "spec.template.spec.hostNetwork"
    value = "true"
  }

  set {
    name  = "controller.service.type"
    value = "NodePort"
  }

  set {
    name  = "controller.publishService.enabled"
    value = "false"
  }

  set {
    name  = "controller.extraArgs.publish-status-address"
    value = "localhost"
  }

  set {
    name  = "controller.watchIngressWithoutClass"
    value = "true"
  }

  # Bit jank
  set {
    name  = "controller.tolerations[0].key"
    value = "node-role.kubernetes.io/control-plane"
  }

  set {
    name  = "controller.tolerations[0].operator"
    value = "Equal"
  }

  set {
    name  = "controller.tolerations[0].effect"
    value = "NoSchedule"
  }

}
