# == Define: virtualenvwrapper::user
#
# Create virtualenvwrapper dir and add if to env and bash
#
# === Parameters
#
# [*plugin_name*]
#   The name of the plugin. Default to resource title.
#
# [*user*]
#   The user under which the plugin will be added. Ignored on Windows
#   systems (current user is assumed).
#
define virtualenvwrapper::user(
  $user           = undef, #$::id,
  $envs_dir_rel_path = undef, #'venvs',
  $envs_dir_full_path = undef
) {
  include virtualenvwrapper::params
  if ($user == undef) {
    if (check_user_exists($title)) {
      $_user = $title
    } else {
      if (check_if_single_word($title)) {
        fail("User $title doesn't exist")
      }
    }
  } else {
    $_user = $user
  }
  if ($envs_dir_rel_path  == undef) {
     $envs_dir_rel_path = virtualenvwrapper::params::envs_dir_rel_path
  }
  $user_home_dir = get_user_home_dir($_user)
  if ($envs_dir_full_path  == undef) {
    $_envs_dir_full_path = "${user_home_dir}/${envs_dir_rel_path}"
  } else {
    $_envs_dir_full_path = $envs_dir_full_path
  }
  $_user_bashrc_path = "${user_home_dir}/.bashrc"
  $virtualenvwrapper = find_virtualenvwrapper()
  file {"${_envs_dir_full_path}": ensure => directory, } ->
  file { "${_user_bashrc_path}": ensure => present } ->
  file_line { "add_workon_to_${_user_bashrc_path}": 
    path => "${_user_bashrc_path}",
    ensure => present,
    line => "export WORKON_HOME=${_envs_dir_full_path}",
  } ->
  virtualenvwrapper::add_virtualenvwrapper{"${_user_bashrc_path}": }
}
