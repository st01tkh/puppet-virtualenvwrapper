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
  $user           = $::id,
  $envs_dir_rel_path = 'venvs',
  $envs_dir_full_path = undef
) {
  include virtualenvwrapper::params
  if ($user == undef) {
    $_user = $title
  } else {
    $_user = $user
  }
  $user_home_dir = get_user_home_dir($_user)
  if ($envs_dir_full_path  == undef) {
    $_envs_dir_full_path = "${user_home_dir}/${envs_dir_rel_path}"
  } else {
    $_envs_dir_full_path = $envs_dir_full_path
  }
  notify { "virtualenvs_dir: ${_envs_dir_full_path}": }
  $_user_bashrc_path = "${user_home_dir}/.bashrc"
  notify { "_user_bashrc_path: ${_user_bashrc_path}": }
  file {"${_envs_dir_full_path}": ensure => directory, } ->
  file { "${_user_bashrc_path}": ensure => present } ->
  file_line { "add_workon_to_${_user_bashrc_path}": 
    path => "${_user_bashrc_path}",
    ensure => present,
    line => "export WORKON_HOME=${_envs_dir_full_path}",
  }

  #if $plugin_version == undef {
  #  $plugin_command = "${vagrant::params::binary} plugin install ${plugin_name}"
  #  $plugin_unless = "${vagrant::params::binary} plugin list | ${vagrant::params::grep} \"^${plugin_name}\s\""
  #} else {
  #  $plugin_command = "${vagrant::params::binary} plugin install ${plugin_name} --plugin-version ${plugin_version}"
  #  $plugin_unless = "${vagrant::params::binary} plugin list | ${vagrant::params::grep} \"^${plugin_name}\s(${plugin_version})\""
  #}

  #vagrant::command { "Install vagrant plugin ${plugin_name} for user ${user}":
  #  command => $plugin_command,
  #  unless => $plugin_unless,
  #  user   => $user,
  #}
}
