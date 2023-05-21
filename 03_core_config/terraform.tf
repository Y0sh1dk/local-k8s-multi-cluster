terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.20.0"
    }
    argocd = {
      source  = "oboukili/argocd"
      version = ">= 5.3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0.4"
    }
  }
  backend "local" {
    path = "../tf_states/03_core_config.tfstate"
  }
}

