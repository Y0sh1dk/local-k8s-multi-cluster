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

variable "query_stores" {
  type = list(string)
}
