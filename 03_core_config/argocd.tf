resource "null_resource" "add_cluster" {
  triggers = {
    time = timestamp()
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
        POD_ID=$(kubectl --context $KUBECTL_CONTEXT -n $ARGOCD_NAMESPACE get pod | grep 'argocd-server' | awk 'END {print $1}' | xargs echo)
        CONTEXTS=$(yq '.clusters.[].name' $INCLUSTER_KUBECONFIG)
        kubectl --context $KUBECTL_CONTEXT -n $ARGOCD_NAMESPACE cp $INCLUSTER_KUBECONFIG $POD_ID:/tmp
        kubectl --context $KUBECTL_CONTEXT -n $ARGOCD_NAMESPACE exec $POD_ID -- sh -c 'echo "y" | argocd login localhost:8080 --username ${local.argocd_config.admin_username} --password ${local.argocd_config.admin_password} --insecure'
        for context in $CONTEXTS
        do
            kubectl --context $KUBECTL_CONTEXT -n $ARGOCD_NAMESPACE exec $POD_ID -- argocd cluster add $context --name $context --kubeconfig /tmp/incluster_kubeconfig
        done
    EOT
    environment = {
      "KUBECONFIG"           = "${local.k8s_config_dir}/kubeconfig"
      "INCLUSTER_KUBECONFIG" = local_file.incluster_kubeconfig.filename
      "KUBECTL_CONTEXT"      = "kind-management-cluster"
      "ARGOCD_NAMESPACE"     = local.argocd_config.chart_metadata[0].namespace
      "ARGOCD_USERNAME"      = local.argocd_config.admin_username
      "ARGOCD_PASSWORD"      = local.argocd_config.admin_password
    }
  }

  depends_on = [local_file.incluster_kubeconfig]
}
