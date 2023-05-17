provider "argocd" {
  server_addr = "localhost:80"
  username    = data.terraform_remote_state.tf_02_core_services.outputs.argocd_config.admin_username
  password    = data.terraform_remote_state.tf_02_core_services.outputs.argocd_config.admin_password
}

provider "helm" {
  kubernetes {
    config_path    = local.k8s_config_path
    config_context = "kind-management-cluster"
  }
}

provider "kubernetes" {
  config_path    = local.k8s_config_path
  config_context = "kind-management-cluster"
}
