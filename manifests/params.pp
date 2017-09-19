# == Class: virtualenvwrapper::params
#
# OS-dependent parameters for vagrant module.
#
class virtualenvwrapper::params {
  $user = $::id
  $user_home_dir_path = undef
  $envs_dir_rel_path = "venvs"
  $envs_dir_full_path = "${user_home_dir_path}/${envs_dir_rel_path}"
  $use_home_var = true
  $pyvenv_search_pattern = 'pyvenv-*'
  $pyvenv_source_path = $::osfamily ? {
    'windows' => undef,
    default   => '/usr/bin/pyvenv'
  }
}
