locals {
  k8s_config_dir = pathexpand("${path.cwd}/../contexts")
  tf_state_path  = pathexpand("${path.cwd}/../tf_state")

  kubeconfig_json = yamldecode(data.local_file.kubeconfig.content)

  kubeconfig_cluster_configs = { for cluster in local.kubeconfig_json.clusters : cluster.name => { address = cluster.cluster.server, certificate-authority-data = cluster.cluster.certificate-authority-data } }
  kubeconfig_user_configs    = { for user in local.kubeconfig_json.users : user.name => { client-certificate-data = user.user.client-certificate-data, client-key-data = user.user.client-key-data } }

  incluster_kubeconfig_cluster_addresses = [for cluster in local.kubeconfig_json.clusters : merge(cluster, { "cluster" : { server : "https://${trimprefix(cluster.name, "kind-")}-control-plane:6443" } })]

  incluster_kubeconfig_clusters_block = [
    for cluster in local.incluster_kubeconfig_cluster_addresses : {
      name = cluster.name
      cluster = {
        certificate-authority-data = local.kubeconfig_json.clusters[index(local.incluster_kubeconfig_cluster_addresses, cluster)].cluster.certificate-authority-data
        server                     = cluster.cluster.server
    } }
  ]

  incluster_kubeconfig = merge(local.kubeconfig_json, { clusters : local.incluster_kubeconfig_clusters_block })

  cluster_credentials = {
    for cluster in keys(local.kubeconfig_cluster_configs) : cluster => {
      address                    = local.kubeconfig_cluster_configs[cluster].address
      certificate-authority-data = local.kubeconfig_cluster_configs[cluster].certificate-authority-data
      client-certificate-data    = local.kubeconfig_user_configs[cluster].client-certificate-data
      client-key-data            = local.kubeconfig_user_configs[cluster].client-key-data
    }
  }

  argocd_config        = data.terraform_remote_state.tf_02_core_services.outputs.argocd_config
  ingress_nginx_config = data.terraform_remote_state.tf_02_core_services.outputs.ingress_nginx_config
}

################## Kubeconfigs ##################
data "local_file" "kubeconfig" {
  filename = "${local.k8s_config_dir}/config"
}

resource "local_file" "incluster_kubeconfig" {
  content         = replace(yamlencode(local.incluster_kubeconfig), "/((?:^|\n)[\\s-]*)\"([\\w-]+)\":/", "$1$2:")
  file_permission = 644
  filename        = "${local.k8s_config_dir}/incluster_kubeconfig"
}
