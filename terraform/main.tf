resource "kind_cluster" "default" {
  for_each = { for cluster in var.clusters : cluster.name => cluster }

  name            = each.value.name
  node_image      = "kindest/node:v1.26.3"
  wait_for_ready  = true
  kubeconfig_path = local.k8s_config_path

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    dynamic "node" {
      for_each = range(each.value.cp_nodes)
      content {
        role = "control-plane"
      }
    }

    dynamic "node" {
      for_each = range(each.value.worker_nodes)
      content {
        role = "worker"
      }
    }

  }
}


locals {
  k8s_config_path = pathexpand("${path.cwd}/../contexts/config")
}
