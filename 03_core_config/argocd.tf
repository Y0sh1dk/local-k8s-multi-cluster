resource "null_resource" "argocd_clusters" {
  triggers = {
    incluster_kubeconfig = local_file.incluster_kubeconfig.content_base64
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
        POD_ID=$(kubectl --context $KUBECTL_CONTEXT -n $ARGOCD_NAMESPACE get pod | grep 'argocd-server' | awk 'END {print $1}' | xargs echo)
        CONTEXTS=$(yq '.clusters.[].name' $INCLUSTER_KUBECONFIG)
        kubectl --context $KUBECTL_CONTEXT -n $ARGOCD_NAMESPACE cp $INCLUSTER_KUBECONFIG $POD_ID:$ARGOCD_POD_DIRECTORY
        task in-network -- argocd login management-cluster-control-plane --username ${local.argocd_config.admin_username} --password ${local.argocd_config.admin_password} --insecure --grpc-web
        for context in $CONTEXTS
        do
          if [ "$context" != "$KUBECTL_CONTEXT" ]; then
            task in-network -- argocd cluster add $context --name $context --kubeconfig contexts/incluster_kubeconfig
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
