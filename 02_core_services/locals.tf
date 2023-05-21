locals {
  k8s_config_dir = pathexpand("${path.cwd}/../contexts")
  tf_state_path  = pathexpand("${path.cwd}/../tf_states")

}
