# == Class: virtualenvwrapper::pyvenv
#
# OS-dependent parameters for vagrant module.
#
include virtualenvwrapper::params

define virtualenvwrapper::pyvenv(
  $search_pattern = undef,
  $source_path = undef,
  $target_path = undef
) {

  case $os['distro']['id'] {
    /Ubuntu|Debian/: {
      if ( !defined(Package["python3-venv"]) ) {
        package {"python3-venv": ensure => installed }
      }
    }
  }

  case $::osfamily {
    'windows': { fail("$::osfamily is not supported yet.") }
  }

  include virtualenvwrapper::params

  if ( $search_pattern == undef ) {
    $_search_pattern = $virtualenvwrapper::params::pyvenv_search_pattern
  } else {
    $_search_pattern = $search_pattern
  }

  if ( $source_path == undef ) {
    $_source_path = $virtualenvwrapper::params::pyvenv_source_path
  } else {
    $_source_path = $source_path
  }
  if ( $_source_path == undef ) {
    fail("pyvenv's source_path is not defined")
  }

  if ( $target_path == undef ) {
    $_target_path = $virtualenvwrapper::params::pyvenv_target_path
  } else {
    $_target_path = $target_path
  }
  if ( $_target_path == undef ) {
    $pyvenv_found_ar = find_files_in_path_dirs('pyvenv-*')
    if empty($pyvenv_found_ar) {
      fail("pyvenv-* not found")
    } else {
      $__target_path = $pyvenv_found_ar[0]
      notify{"Found ${__target_path} in PATH's dirs": }
    }
  }
  if ( $__target_path == undef ) {
    fail("pyvenv's target neither found nor defined")
  }

  if ( !defined(File["$_source_path"]) ) {
    file { "$_source_path": ensure => link , target => "$__target_path" }
  }
}
