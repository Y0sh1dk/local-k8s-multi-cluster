resource "null_resource" "linkerd_multi_cluster" {
  triggers = {
    incluster_kubeconfig = local_file.incluster_kubeconfig.content_base64
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
        CONTEXTS=$(yq '.clusters.[].name' $KUBECONFIG)
        for CONTEXT_A in $CONTEXTS
        do
          for CONTEXT_B in $CONTEXTS
          do
            if [ $CONTEXT_A != $CONTEXT_B ]; then
              CLUSTER_A_GATEWAY_ADDRESS=$${CONTEXT_A#"kind-"}-control-plane
              echo "Linking $CONTEXT_A to $CONTEXT_B with $CLUSTER_A_GATEWAY_ADDRESS gateway"
              LINKERD_LINK_COMMAND="linkerd --context $CONTEXT_A multicluster link --cluster-name $CONTEXT_A --gateway-addresses $CLUSTER_A_GATEWAY_ADDRESS | kubectl --context $CONTEXT_B apply -f -"
              task in-network -- "$LINKERD_LINK_COMMAND"
            fi
          done
        done
    EOT
    environment = {
      "KUBECONFIG" = local_file.incluster_kubeconfig.filename
    }
  }

  depends_on = [local_file.incluster_kubeconfig]
}
