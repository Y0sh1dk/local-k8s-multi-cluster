variable "clusters" {
  type = list(object({
    name       = string
    node_image = optional(string, "kindest/node:v1.26.3")
    nodes = list(object({
      role                   = string
      kubeadm_config_patches = optional(list(string))
      extra_port_mappings = optional(list(object({
        listen_address = optional(string, "0.0.0.0")
        container_port = string
        host_port      = string
        protocol       = string
      })), [])
    }))
  }))
  default = []

  validation {
    condition = alltrue(
      [
        for cluster in var.clusters : alltrue(
          [for node in cluster.nodes : contains(
            ["control-plane", "worker"], node.role)
          ]
        )
      ]
    )
    error_message = "Invalid node type, nodes can only be \"control-plane\" or \"worker\"."
  }

  validation {
    condition = length(
      flatten(
        [for cluster in var.clusters :
          [for node in cluster.nodes :
            [for mapping in node.extra_port_mappings : mapping.host_port]
          ]
        ]
      )
      ) == length(
      distinct(
        flatten(
          [for cluster in var.clusters :
            [for node in cluster.nodes :
              [for mapping in node.extra_port_mappings : mapping.host_port]
            ]
          ]
        )
      )
    )
    error_message = "Duplicate host ports."
  }

  validation {
    condition = alltrue(
      flatten(
        [for cluster in var.clusters :
          [for node in cluster.nodes :
            length(
              [for mapping in node.extra_port_mappings : mapping.container_port]
              ) == length(
              distinct(
                [for mapping in node.extra_port_mappings : mapping.container_port]
              )
            )
          ]
        ]
      )
    )
    error_message = "Duplicate container ports."
  }
}
