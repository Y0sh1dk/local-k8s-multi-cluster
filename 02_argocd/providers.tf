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
