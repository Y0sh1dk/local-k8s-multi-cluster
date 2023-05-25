resource "kubernetes_namespace" "thanos" {
  metadata {
    name = "thanos"
    annotations = {
      // Needed to have access to mirrored services
      "linkerd.io/inject" = "enabled"
    }
  }
}

module "thanos_kind_management_cluster" {
  source = "./modules/thanos"

  namespace        = kubernetes_namespace.thanos.metadata[0].name
  create_namespace = true

  query_stores = [
    "dnssrv+_grpc._tcp.kube-prometheus-prometheus-thanos.kube-prometheus.svc.cluster.local:10901",
    "dnssrv+_grpc._tcp.kube-prometheus-prometheus-thanos-kind-worker-cluster-01.kube-prometheus.svc.cluster.local:10901",
    "dnssrv+_grpc._tcp.kube-prometheus-prometheus-thanos-kind-worker-cluster-02.kube-prometheus.svc.cluster.local:10901"
  ]

  providers = {
    helm = helm.kind-management-cluster
  }

  depends_on = [module.linkerd_kind_management_cluster]
}
