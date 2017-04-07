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
  $envs_dir_full_path = undef,
  $use_home_var = true
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
     $_envs_dir_rel_path = virtualenvwrapper::params::envs_dir_rel_path
  } else {
     $_envs_dir_rel_path = $envs_dir_rel_path
  }
  if ($use_home_var == undef) {
     $_use_home_var = virtualenvwrapper::params::use_home_var
  } else {
     $_use_home_var = $use_home_var
  }
  $home = "home_${_user}"
  $user_home_dir = inline_template("<%= scope.lookupvar('::$home') %>")
  $user_uid = inline_template("<%= scope.lookupvar('::$uid') %>")
  if ( $user_uid == "" ) {
    $user_exists = false
  } else {
    $user_exists = true
  }
  if (!$user_exists) {
    fail("User ${_user} doesn't exist")
  }
  if ($envs_dir_full_path == undef) {
    if ($_use_home_var) {
      $_envs_dir_full_path = "\$HOME/${_envs_dir_rel_path}"
    } else {
      $_envs_dir_full_path = "${user_home_dir}/${_envs_dir_rel_path}"
    }
  } else {
    $_envs_dir_full_path = $envs_dir_full_path
  }
  $_user_bashrc_path = "${user_home_dir}/.bashrc"
  if (!$_use_home_var) {
    file { "${_envs_dir_full_path}": ensure => directory }
  }
  file { "${_user_bashrc_path}": ensure => present } ->
  file_line { "add_workon_to_${_user_bashrc_path}": 
    path => "${_user_bashrc_path}",
    ensure => present,
    line => "export WORKON_HOME=${_envs_dir_full_path}",
  } ->
  virtualenvwrapper::add_virtualenvwrapper{"${_user_bashrc_path}": }
}
