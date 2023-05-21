# linkerd Mutual TLS certs
resource "tls_private_key" "trustanchor_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_self_signed_cert" "trustanchor_cert" {
  private_key_pem       = tls_private_key.trustanchor_key.private_key_pem
  validity_period_hours = 87600
  is_ca_certificate     = true

  subject {
    common_name = "identity.linkerd.cluster.local"
  }

  allowed_uses = [
    "crl_signing",
    "cert_signing",
    "server_auth",
    "client_auth"
  ]
}

resource "tls_private_key" "issuer_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_cert_request" "issuer_req" {
  private_key_pem = tls_private_key.issuer_key.private_key_pem

  subject {
    common_name = "identity.linkerd.cluster.local"
  }
}

resource "tls_locally_signed_cert" "issuer_cert" {
  cert_request_pem      = tls_cert_request.issuer_req.cert_request_pem
  ca_private_key_pem    = tls_private_key.trustanchor_key.private_key_pem
  ca_cert_pem           = tls_self_signed_cert.trustanchor_cert.cert_pem
  validity_period_hours = 8760
  is_ca_certificate     = true

  allowed_uses = [
    "crl_signing",
    "cert_signing",
    "server_auth",
    "client_auth"
  ]
}

module "linkerd_kind_management_cluster" {
  source = "./modules/linkerd"

  namespace        = "linkerd"
  create_namespace = true

  idenity_trust_anchors_pem   = tls_self_signed_cert.trustanchor_cert.cert_pem
  identity_issuer_crt_expiry  = tls_locally_signed_cert.issuer_cert.validity_end_time
  identity_issuer_tls_crt_pem = tls_locally_signed_cert.issuer_cert.cert_pem
  identity_issuer_tls_key_pem = tls_private_key.issuer_key.private_key_pem

  providers = {
    helm = helm.kind-management-cluster
  }
}

module "linkerd_kind_worker_cluster_01" {
  source = "./modules/linkerd"

  namespace        = "linkerd"
  create_namespace = true

  idenity_trust_anchors_pem   = tls_self_signed_cert.trustanchor_cert.cert_pem
  identity_issuer_crt_expiry  = tls_locally_signed_cert.issuer_cert.validity_end_time
  identity_issuer_tls_crt_pem = tls_locally_signed_cert.issuer_cert.cert_pem
  identity_issuer_tls_key_pem = tls_private_key.issuer_key.private_key_pem

  providers = {
    helm = helm.kind-worker-cluster-01
  }
}

module "linkerd_kind_worker_cluster_02" {
  source = "./modules/linkerd"

  namespace        = "linkerd"
  create_namespace = true

  idenity_trust_anchors_pem   = tls_self_signed_cert.trustanchor_cert.cert_pem
  identity_issuer_crt_expiry  = tls_locally_signed_cert.issuer_cert.validity_end_time
  identity_issuer_tls_crt_pem = tls_locally_signed_cert.issuer_cert.cert_pem
  identity_issuer_tls_key_pem = tls_private_key.issuer_key.private_key_pem

  providers = {
    helm = helm.kind-worker-cluster-02
  }
}

module "linkerd_multicluster_kind_management_cluster" {
  source = "./modules/linkerd-multicluster"

  namespace        = "linkerd-multicluster"
  create_namespace = true

  providers = {
    helm = helm.kind-management-cluster
  }

  depends_on = [moduel.linkerd_kind_management_cluster]
}

module "linkerd_multicluster_kind_worker_cluster_01" {
  source = "./modules/linkerd-multicluster"

  namespace        = "linkerd-multicluster"
  create_namespace = true

  providers = {
    helm = helm.kind-worker-cluster-01
  }

  depends_on = [module.linkerd_kind_worker_cluster_01]
}

module "linkerd_multicluster_kind_worker_cluster_02" {
  source = "./modules/linkerd-multicluster"

  namespace        = "linkerd-multicluster"
  create_namespace = true

  providers = {
    helm = helm.kind-worker-cluster-02
  }

  depends_on = [module.linkerd_kind_worker_cluster_02]
}
