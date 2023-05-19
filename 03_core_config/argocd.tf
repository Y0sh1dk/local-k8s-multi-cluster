resource "null_resource" "add_cluster" {
  triggers = {
    time = timestamp()
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
        POD_ID=$(kubectl --context $KUBECTL_CONTEXT get pod -n argocd | grep 'argocd-server' | awk 'END {print $1}' | xargs echo)
        CONTEXTS=$(yq '.clusters.[].name' ${local_file.new_kubeconfig.filename})
        kubectl --context $KUBECTL_CONTEXT cp -n argocd ${local_file.new_kubeconfig.filename} $POD_ID:/tmp
        kubectl --context $KUBECTL_CONTEXT -n argocd exec $POD_ID -- sh -c 'echo "y" | argocd login localhost:8080 --username admin --password testpassword --insecure'
        for context in $CONTEXTS
        do
            kubectl --context $KUBECTL_CONTEXT -n argocd exec $POD_ID -- argocd cluster add $context --name $context --kubeconfig /tmp/incluster_kubeconfig
        done
    EOT
    environment = {
      "KUBECONFIG"      = "${local.k8s_config_dir}/config"
      "KUBECTL_CONTEXT" = "kind-management-cluster"
    }
  }

  depends_on = [local_file.new_kubeconfig]
}
