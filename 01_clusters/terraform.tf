terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "0.0.17"
    }
  }
  backend "local" {
    path = "../tf_states/01_clusters.tfstate"
  }
}
