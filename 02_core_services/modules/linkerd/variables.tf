variable "namespace" {
  type = string
}

variable "create_namespace" {
  type    = bool
  default = false
}

variable "timeout" {
  type    = number
  default = 900
}

variable "idenity_trust_anchors_pem" {
  type = string
}

variable "identity_issuer_crt_expiry" {
  type = string
}

variable "identity_issuer_tls_crt_pem" {
  type = string
}

variable "identity_issuer_tls_key_pem" {
  type = string
}
