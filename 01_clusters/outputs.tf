output "cluster_configs" {
  value = [
    for cluster in kind_cluster.this :
    {
      name                   = cluster.name
      endpoint               = cluster.endpoint
      kubeconfig_path        = cluster.kubeconfig_path
      client_certificate     = cluster.client_certificate
      client_key             = cluster.client_key
      cluster_ca_certificate = cluster.cluster_ca_certificate
    }
  ]
}
