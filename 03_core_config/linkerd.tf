resource "null_resource" "linkerd_multi_cluster" {
  triggers = {
    time = timestamp()
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
        task in-network -- linkerd --context=kind-worker-cluster-01 multicluster link --cluster-name kind-worker-cluster-01 --gateway-addresses worker-cluster-01-control-plane | kubectl --context=kind-worker-cluster-02 apply -f -
        task in-network -- linkerd --context=kind-worker-cluster-02 multicluster link --cluster-name kind-worker-cluster-02 --gateway-addresses worker-cluster-02-control-plane | kubectl --context=kind-worker-cluster-01 apply -f -
    EOT
    environment = {
      "KUBECONFIG"           = "${local.k8s_config_dir}/kubeconfig"
      "INCLUSTER_KUBECONFIG" = local_file.incluster_kubeconfig.filename
      "KUBECTL_CONTEXT"      = "kind-management-cluster"
      "ARGOCD_NAMESPACE"     = local.argocd_config.chart_metadata[0].namespace
      "ARGOCD_USERNAME"      = local.argocd_config.admin_username
      "ARGOCD_PASSWORD"      = local.argocd_config.admin_password
      "ARGOCD_POD_DIRECTORY" = "/tmp"
    }
  }

  depends_on = [local_file.incluster_kubeconfig]
}
