locals {
  k8s_config_path = pathexpand("${path.cwd}/../contexts/config")
  tf_state_path   = pathexpand("${path.cwd}/../tf_state")

}
