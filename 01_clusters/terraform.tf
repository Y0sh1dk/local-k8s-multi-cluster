terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "0.0.17"
    }
  }
  backend "local" {
    path = "../tf_state/01_clusters.tfstate"
  }
}
