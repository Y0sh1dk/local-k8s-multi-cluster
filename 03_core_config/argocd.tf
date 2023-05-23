resource "null_resource" "argocd_clusters" {
  triggers = {
    incluster_kubeconfig = local_file.incluster_kubeconfig.content_base64
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
        CONTEXTS=$(yq '.clusters.[].name' $INCLUSTER_KUBECONFIG)
        ARGOCD_LOGIN_COMMAND="argocd login management-cluster-control-plane --username ${local.argocd_config.admin_username} --password ${local.argocd_config.admin_password} --insecure --grpc-web"
        task in-network -- "$ARGOCD_LOGIN_COMMAND"
        for CONTEXT in $CONTEXTS
        do
          if [ "$CONTEXT" != "$KUBECTL_CONTEXT" ]; then
            ARGOCD_CLUSTER_ADD_COMMAND="argocd cluster add $CONTEXT --name $CONTEXT --kubeconfig contexts/incluster_kubeconfig"
            task in-network -- "$ARGOCD_CLUSTER_ADD_COMMAND"
          fi
        done
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
