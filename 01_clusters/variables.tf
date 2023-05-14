variable "clusters" {
  type = list(object({
    name         = string
    node_image   = optional(string, "kindest/node:v1.26.3")
    cp_nodes     = optional(number, 1)
    worker_nodes = optional(number, 1)
  }))
}
