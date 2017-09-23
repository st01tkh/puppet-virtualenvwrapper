# == Class: virtualenvwrapper::params
#
# OS-dependent parameters for vagrant module.
#
class virtualenvwrapper::params {
  $user = $::id
  $user_home_dir_path = undef
  $envs_dir_rel_path = ".virtualenvs"
  $proj_dir_rel_path = "projects"
  $use_home_var = true
  $pyvenv_search_pattern = 'pyvenv-*'
  $pyvenv_source_path = $::osfamily ? {
    'windows' => undef,
    default   => '/usr/bin/pyvenv'
  }
  case $os['distro']['id'] {
    /Ubuntu|Debian/: {
      $loader_path = "/usr/share/virtualenvwrapper/virtualenvwrapper.sh"
      $lazy_loader_path = "/usr/share/virtualenvwrapper/virtualenvwrapper_lazy.sh"
    }
    default: {
      $loader_path = "/usr/local/bin/virtualenvwrapper.sh"
      $lazy_loader_path = "/usr/local/bin/virtualenvwrapper_lazy.sh"
    }
  }
}
