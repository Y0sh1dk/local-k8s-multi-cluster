
variable "namespace" {
  description = "Namespace to install ArgoCD chart into"
  type        = string
  default     = "argocd"
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

variable "admin_password" {
  description = "Default Admin Password"
  type        = string
}

variable "insecure" {
  type        = bool
  description = "Disable TLS on the ArogCD API Server?"
  default     = false
}
