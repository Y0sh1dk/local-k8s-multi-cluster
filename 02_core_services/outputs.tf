output "argocd_config" {
  value = {
    chart_metadata = helm_release.argocd.metadata
    admin_username = "admin"
    admin_password = var.argocd_admin_password
  }
}

output "ingress_nginx_config" {
  value = {
    chart_metadata = helm_release.ingress_nginx.metadata
  }
}
