data "terraform_remote_state" "tf_01_clusters" {
  backend = "local"

  config = {
    path = "${local.tf_state_path}/01_clusters.tfstate"
  }
}

data "terraform_remote_state" "tf_02_core_services" {
  backend = "local"

  config = {
    path = "${local.tf_state_path}/02_core_services.tfstate"
  }
}
