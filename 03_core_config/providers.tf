provider "argocd" {
  server_addr = "localhost:80"
  username    = data.terraform_remote_state.tf_02_core_services.outputs.argocd_config.admin_username
  password    = data.terraform_remote_state.tf_02_core_services.outputs.argocd_config.admin_password
}

provider "helm" {
  kubernetes {
    config_path    = "${local.k8s_config_dir}/kubeconfig"
    config_context = "kind-management-cluster"
  }
  alias = "kind-management-cluster"
}

provider "helm" {
  kubernetes {
    config_path    = "${local.k8s_config_dir}/kubeconfig"
    config_context = "kind-worker-cluster-01"
  }
  alias = "kind-worker-cluster-01"
}

provider "helm" {
  kubernetes {
    config_path    = "${local.k8s_config_dir}/kubeconfig"
    config_context = "kind-worker-cluster-03"
  }
  alias = "kind-worker-cluster-02"
}

provider "kubernetes" {
  config_path    = "${local.k8s_config_dir}/kubeconfig"
  config_context = "kind-management-cluster"
}
