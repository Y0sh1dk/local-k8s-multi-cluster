data "terraform_remote_state" "tf_01_clusters" {
  backend = "local"

  config = {
    path = "${local.tf_state_path}/01_clusters.tfstate"
  }
}
