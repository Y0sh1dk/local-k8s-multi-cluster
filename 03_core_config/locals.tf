locals {
  k8s_config_path = pathexpand("${path.cwd}/../contexts/config")
  tf_state_path   = pathexpand("${path.cwd}/../tf_state")

  cluster_endpoints = [for cluster in data.terraform_remote_state.tf_01_clusters.outputs.cluster_configs : cluster.endpoint]

  kubeconfig_json = yamldecode(data.local_file.kubeconfig.content)

  cluster_cluster_configs = { for cluster in local.kubeconfig_json.clusters : cluster.name => { address = cluster.cluster.server, certificate-authority-data = cluster.cluster.certificate-authority-data } }
  cluster_user_configs    = { for user in local.kubeconfig_json.users : user.name => { client-certificate-data = user.user.client-certificate-data, client-key-data = user.user.client-key-data } }

  cluster_credentials = {
    for cluster in keys(local.cluster_cluster_configs) : cluster => {
      address                    = local.cluster_cluster_configs[cluster].address
      certificate-authority-data = local.cluster_cluster_configs[cluster].certificate-authority-data
      client-certificate-data    = local.cluster_user_configs[cluster].client-certificate-data
      client-key-data            = local.cluster_user_configs[cluster].client-key-data
    }
  }
}

data "local_file" "kubeconfig" {
  filename = local.k8s_config_path
}

output "cluster_credentials" {
  value = local.cluster_credentials
}
