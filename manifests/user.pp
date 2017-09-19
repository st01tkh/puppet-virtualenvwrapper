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
  $homedir_path = undef,
  $envs_dir_rel_path = undef, #'venvs',
  $use_home_var = true
) {
  include virtualenvwrapper::params

  homedir::file {"$user:~/$envs_dir_rel_path virtualenvwrapper":
    user => $user,
    homedir_path => $homedir_path,
    ensure => directory,
    rel_path => $envs_dir_rel_path, 
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

  if $homedir_path {
    $homedir_path_real = $homedir_path
  } elsif $user == 'root' {
    $homedir_path_real = $::osfamily ? {
      'Solaris' => '/',
      default   => '/root',
    }
  } else {
    $homedir_path_real = $::osfamily ? {
      'Solaris' => "/export/home/${user}",
      default   => "/home/${user}",
    }
  }

  if ($_use_home_var) {
    $_envs_dir_full_path = "\$HOME/${_envs_dir_rel_path}"
  } else {
    $_envs_dir_full_path = "${homedir_path_real}/${_envs_dir_rel_path}"
  }

  homedir::file_line {"$user:~/.bashrc virtualenvwrapper":
    user => $user,
    homedir_path => $homedir_path,
    rel_path => ".bashrc",
    line => "export WORKON_HOME=${_envs_dir_full_path}",
    line_ensure => present,
  }
}

#
# vim: tabstop=2 shiftwidth=2 expandtab
# 
