resource "helm_release" "linkerd_crds" {
  namespace        = var.namespace
  create_namespace = var.create_namespace

  name       = "linkerd-crds"
  repository = "https://helm.linkerd.io/stable"
  chart      = "linkerd-crds"
  version    = "1.6.1"
  timeout    = var.timeout

}

resource "helm_release" "linkerd" {
  namespace        = var.namespace
  create_namespace = var.create_namespace

  name       = "linkerd-control-plane"
  repository = "https://helm.linkerd.io/stable"
  chart      = "linkerd-control-plane"
  version    = "1.12.3"
  timeout    = var.timeout

  set {
    name  = "identityTrustAnchorsPEM"
    value = var.idenity_trust_anchors_pem
  }

  set {
    name  = "identity.issuer.crtExpiry"
    value = var.identity_issuer_crt_expiry
  }

  set {
    name  = "identity.issuer.tls.crtPEM"
    value = var.identity_issuer_tls_crt_pem
  }

  set {
    name  = "identity.issuer.tls.keyPEM"
    value = var.identity_issuer_tls_key_pem
  }

  depends_on = [helm_release.linkerd_crds]
}

resource "helm_release" "linkerd_viz" {
  name             = "viz"
  namespace        = "${var.namespace}-viz"
  create_namespace = var.create_namespace
  repository       = "https://helm.linkerd.io/stable"
  chart            = "linkerd-viz"
  timeout          = var.timeout

  depends_on = [helm_release.linkerd_crds, helm_release.linkerd]
}
