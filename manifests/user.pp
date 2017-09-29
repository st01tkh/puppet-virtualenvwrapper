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
  $startup_script = ".bashrc",

  $add_workon_home = true,
  $add_projects_home = false,

  $add_loader = true,
  $loader_path = undef,
  $lazy_loader_path = undef,
  $use_lazy_loader = true,

  $envs_dir_rel_path = undef, 
  $envs_dir_full_path = undef, 

  $proj_dir_rel_path = undef,
  $proj_dir_full_path = undef,

  $use_home_var = true
) {

  include virtualenvwrapper::params

  if ($envs_dir_rel_path == undef) {
    $_envs_dir_rel_path = $virtualenvwrapper::params::envs_dir_rel_path
  } else {
    $_envs_dir_rel_path = $envs_dir_rel_path
  }

  if ($proj_dir_rel_path == undef) {
    $_proj_dir_rel_path = $virtualenvwrapper::params::proj_dir_rel_path
  } else {
    $_proj_dir_rel_path = $proj_dir_rel_path
  }

  if ($use_home_var == undef) {
    $_use_home_var = $virtualenvwrapper::params::use_home_var
  } else {
    validate_bool($use_home_var)
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

  case $facts['kernel'] {
    'Linux' : {
      case $facts['os']['family'] {
        'RedHat', 'Amazon' : {
          ensure_packages(['virtualenvwrapper'], {
            'provider' => 'pip',
            'ensure'   => 'present',
          })
        }
        'Debian', 'Ubuntu' : {
          notify {"HEEEEEE": }
          ensure_packages(['virtualenvwrapper'], {
            'provider' => 'pip',
            'ensure' => 'present',
          })
        }
      }
    }
    default : {
      fail ("unsupported platform ${$facts['os']['name']}")
    }
  }

  if $envs_dir_full_path == undef {
    if ($_use_home_var) {
      $_envs_dir_full_path = "\$HOME/${_envs_dir_rel_path}"
    } else {
      $_envs_dir_full_path = "${homedir_path_real}/${_envs_dir_rel_path}"
    }
    if $add_workon_home {
      homedir::file {"$user:~/$envs_dir_rel_path virtualenvwrapper envs dir":
        user => $user,
        homedir_path => $homedir_path,
        ensure => directory,
        rel_path => $_envs_dir_rel_path, 
      }
    }
  } else {
    $_envs_dir_full_path = $envs_dir_full_path
    if $add_workon_home {
      if !defined(File["$_envs_dir_full_path"]) {
        $group_real = $user
        if !defined(Group[$group_real]) {
          group { "$group_real":
            ensure => present,
          }
        }
        file {"$_envs_dir_full_path":
          owner => $user,
          group => $group_real,
          mode => '0755',
          ensure => directory,
        }
      }
    }
  }

  if $proj_dir_full_path == undef {
    if ($_use_home_var) {
      $_proj_dir_full_path = "\$HOME/${_proj_dir_rel_path}"
    } else {
      $_proj_dir_full_path = "${homedir_path_real}/${_proj_dir_rel_path}"
    }
    if $add_projects_home {
      homedir::file {"$user:~/$proj_dir_rel_path virtualenvwrapper projects dir":
        user => $user,
        homedir_path => $homedir_path,
        ensure => directory,
        rel_path => $_proj_dir_rel_path, 
      }
    }
  } else {
    $_proj_dir_full_path = $proj_dir_full_path
    if $add_projects_home {
      if !defined(File["$_proj_dir_full_path"]) {
        $group_real = $user
        if !defined(Group[$group_real]) {
          group { "$group_real":
            ensure => present,
          }
        }
        file {"$_proj_dir_full_path":
          owner => $user,
          group => $group_real,
          mode => '0755',
          ensure => directory,
        }
      }
    }
  }

  if $add_workon_home {
    $wh_remove_name = "remove virtualenvwrapper WORKON_HOME in $user's .bashrc"
    $wh_add_name = "add virtualenvwrapper WORKON_HOME in $user's .bashrc"
    homedir::file_line {"$wh_remove_name":
      line_name => $wh_remove_name,
      user => $user,
      homedir_path => $homedir_path,
      rel_path => $startup_script,
      line => "export WORKON_HOME=${_envs_dir_full_path}",
      match => "export WORKON_HOME=.*$",
      multiple => true,
      line_ensure => absent,
      replace => false,
      match_for_absence => true,
    } ->
    homedir::file_line {"$wh_add_name":
      line_name => $wh_add_name,
      user => $user,
      homedir_path => $homedir_path,
      rel_path => $startup_script,
      line => "export WORKON_HOME=${_envs_dir_full_path}",
      match => "export WORKON_HOME=.*$",
      multiple => true,
      line_ensure => present,
      replace => true,
    }
  }

  if $add_projects_home {
    $ph_remove_name = "remove virtualenvwrapper PROJECTS_HOME in $user's .bashrc"
    $ph_add_name = "add virtualenvwrapper PROJECTS_HOME in $user's .bashrc"
    homedir::file_line {"$ph_remove_name":
      line_name => $ph_remove_name,
      user => $user,
      homedir_path => $homedir_path,
      rel_path => $startup_script,
      line => "export PROJECTS_HOME=${_proj_dir_full_path}",
      match => "export PROJECTS_HOME=.*$",
      multiple => true,
      line_ensure => absent,
      replace => false,
      match_for_absence => true,
    } ->
    homedir::file_line {"$ph_add_name":
      line_name => $ph_add_name,
      user => $user,
      homedir_path => $homedir_path,
      rel_path => $startup_script,
      line => "export PROJECTS_HOME=${_proj_dir_full_path}",
      match => "export PROJECTS_HOME=.*$",
      multiple => true,
      line_ensure => present,
      replace => true,
    }
  }

  if $add_loader {
    if $use_lazy_loader {
      if $lazy_loader_path == undef {
        $loader_path_real = $virtualenvwrapper::params::lazy_loader_path
      } else {
        $loader_path_real = $lazy_loader_path
      }
    } else {
      if $loader_path == undef {
        $loader_path_real = $virtualenvwrapper::params::loader_path
      } else {
        $loader_path_real = $loader_path
      }
    }

    if $loader_path_real {
      $l_add_name = "add virtualenvwrapper loader in $user's .bashrc"
      homedir::file_line {"$l_add_name":
        line_name => $l_add_name,
        user => $user,
        homedir_path => $homedir_path,
        rel_path => $startup_script,
        line => "source $loader_path_real",
        line_ensure => present,
        replace => true,
      }
    }
  }

}

#
# vim: tabstop=2 shiftwidth=2 expandtab
# 
