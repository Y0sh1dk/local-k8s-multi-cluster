
variable "argocd_namespace" {
  description = "Namespace to install ArgoCD chart into"
  type        = string
  default     = "argocd"
}

variable "ingress_nginx_namespace" {
  description = "Namespace to install ingress-nginx chart into"
  type        = string
  default     = "ingress-nginx"
}

variable "argocd_chart_version" {
  description = "Version of ArgoCD chart to install"
  type        = string
  default     = "5.33.3"
}

variable "timeout_seconds" {
  type    = number
  default = 800 # 10 minutes
}

variable "argocd_admin_password" {
  description = "Default Admin Password"
  type        = string
}

variable "argocd_insecure" {
  type        = bool
  description = "Disable TLS on the ArogCD API Server?"
  default     = true
}
