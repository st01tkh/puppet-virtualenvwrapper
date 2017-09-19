# == Class: virtualenvwrapper
#
# This is a puppet module to install and configure virtualenvwrapper.
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  class { virtualenvwrapper:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# st01tkh <st01tkh@gmail.com>
#
# === Copyright
#
# Copyright 2016 st01tkh
#
class virtualenvwrapper ( $python_version = undef
) inherits virtualenvwrapper::params
{
  case $::kernel {
    /Darwin,windows/: {
      notify {"virtualenvwrapper puppet module doesn't support $::kernel yet": }
    }
    default: {
      python::pip {'virtualenvwrapper': }
    }
  }
}
