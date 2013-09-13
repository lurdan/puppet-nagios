# Class: nagios::plugins
#
# Parameters:
#  $type: optional, specify default plugins which set of.
#    all: install all prepared plugins.
#    basic: install essential plugins only.
#    (default): OS default.
#  $local: optional, specify the path to use with custom plugins.
#
# Usage:
# class { 'nagios::plugins':
#   local => '/etc/nagios/plugins',
# }
class nagios::plugins ( $type = false, $localpath = false ) {

  case $type {
    'all': {
      package { 'nagios-plugins':
        name => $::osfamily ? {
          'Debian' => 'nagios-plugins',
          'RedHat' => 'nagios-plugins-all',
        },
      }
    }
    'basic': {
      package { 'nagios-plugins':
        name => $::osfamily ? {
          'Debian' => 'nagios-plugins-basic',
          'RedHat' => 'nagios-plugins',
        },
      }
      case $::osfamily {
        'Debian': {
          package { 'nagios-plugins-standard': ensure => purged }
        }
      }
    }
    default: {
     package { 'nagios-plugins': }
    }
  }
}

# Usage:
#  nagios::plugins::local { 'check_foo':
#    source => 'puppet://modules/path/to/plugin',
#    host_args => '-w 10',
#  }
define nagios::plugins::local (
  $path = "${nagios::plugins::localpath}",
  $ensure = 'present',
  $source = undef,
  $args = false
  ) {

  file { "${path}/${name}":
    ensure => $ensure,
    mode => 755, owner => root, group => root,
    source => $source,
    require => File["$nagios::plugins::localpath"]
  }

  if $args {
    nagios::command { "$name":
      args => $host_args,
    }
  }
}
