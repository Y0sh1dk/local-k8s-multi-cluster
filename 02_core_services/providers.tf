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
    config_context = "kind-worker-cluster-02"
  }
  alias = "kind-worker-cluster-02"
}

provider "kubernetes" {
  config_path    = "${local.k8s_config_dir}/kubeconfig"
  config_context = "kind-management-cluster"
}
