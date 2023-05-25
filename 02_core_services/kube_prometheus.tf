module "prometheus_operator_kind_management_cluster" {
  source = "./modules/kube-prometheus"

  namespace        = "kube-prometheus"
  create_namespace = true
  cluster_label    = "kind-management-cluster"

  providers = {
    helm = helm.kind-management-cluster
  }

  depends_on = [module.linkerd_kind_management_cluster]
}

module "prometheus_operator_kind_worker_cluster_01" {
  source = "./modules/kube-prometheus"

  namespace        = "kube-prometheus"
  create_namespace = true
  cluster_label    = "kind-worker-cluster-01"

  providers = {
    helm = helm.kind-worker-cluster-01
  }

  depends_on = [module.linkerd_kind_worker_cluster_01]
}

module "prometheus_operator_kind_worker_cluster_02" {
  source = "./modules/kube-prometheus"

  namespace        = "kube-prometheus"
  create_namespace = true
  cluster_label    = "kind-worker-cluster-02"

  providers = {
    helm = helm.kind-worker-cluster-02
  }

  depends_on = [module.linkerd_kind_worker_cluster_02]
}
