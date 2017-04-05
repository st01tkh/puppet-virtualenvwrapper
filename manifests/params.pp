# == Class: virtualenvwrapper::params
#
# OS-dependent parameters for vagrant module.
#
class virtualenvwrapper::params {
  $user = $::id
  $user_home_dir = get_user_home_dir($user)
  $envs_dir_rel_path = "venvs"
  $envs_dir_full_path = "${user_home_dir}/${envs_dir_rel_path}"

  case $::kernel {
    'Darwin': {
    }
    'windows': {
    }
    'default': {
    }
  }
}
