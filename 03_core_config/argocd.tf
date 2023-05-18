resource "null_resource" "add_cluster" {
  triggers = {
    time = timestamp()
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
        POD_ID=$(kubectl get pod -n argocd | grep 'argocd-server' | awk 'END {print $1}' | xargs echo)
        CONTEXTS=$(yq '.clusters.[].name' ${local_file.new_kubeconfig.filename})
        kubectl cp -n argocd ${local_file.new_kubeconfig.filename} $POD_ID:/tmp
        for context in $CONTEXTS
        do
            kubectl -n argocd exec $POD_ID -- argocd cluster add $context --name $context --kubeconfig /tmp/incluster_kubeconfig
        done
    EOT
    environment = {
      "KUBECONFIG" = "${local.k8s_config_dir}/config"
    }
  }

  depends_on = [local_file.new_kubeconfig]
}
