resource "argocd_cluster" "kubernetes" {
  for_each = local.cluster_credentials

  config {
    tls_client_config {
      ca_data   = each.value.certificate-authority-data
      cert_data = each.value.client-certificate-data
      key_data  = each.value.client-key-data
      insecure  = false
    }
  }

  name   = each.key
  server = each.value.address
}
