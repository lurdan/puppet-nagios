# Class: nagios::cgi

# Usage:
#  class { 'nagios::cgi':
#    config => template('path/to.erb'),
#  }
#
# TODO:
#  * switch config to augeas when sane lenses release
#
class nagios::cgi (
  $version = 'present',
  $config = false
  ) {

  package { 'nagios3-cgi':
    ensure => $version,
  }

  $conffile = "${nagios::confdir}/cgi.cfg"
  concat { "$conffile":
    require => Package['nagios-server'],
  }

  if $config {
    concat::fragment { 'nagios-cgi-config':
      target => "${conffile}",
      content => $config,
      order => '00',
    }
  }
}

define nagios::cgi::config (
  $value,
  $order = '50'
  ) {

  concat::fragment { "nagios-cgi-config-${name}":
    target => "${nagios::cgi::conffile}",
    content => "${name}=${value}\n",
    order => $order,
  }
}
