# Class: nagios::plugins
#
# Parameters:
#  $type: optional, specify default plugins which set of.
#    all: install all prepared plugins.
#    basic: install essential plugins only.
#    (default): obey OS default.
#  $local: optional, specify the path to use with custom plugins.
#
# Usage:
# class { 'nagios::plugins':
#   local => '/etc/nagios/plugins',
# }
class nagios::plugins ( $type = false, $local = false ) {

  if $local {
    $localpath = $local
    file { "$localpath":
      ensure => directory,
      require => Package['nagios-plugins'],
    }
    File["$localpath"] -> Nagios::Plugins::Local <| |>
  }

  case $type {
    'all': {
      package { 'nagios-plugins':
        name => $::operatingsystem ? {
          /(?i-mx:debian|ubuntu)/ => 'nagios-plugins',
          /(?i-mx:redhat|centos)/ => 'nagios-plugins-all',
        },
      }
    }
    'basic': {
      package { 'nagios-plugins':
        name => $::operatingsystem ? {
          /(?i-mx:debian|ubuntu)/ => 'nagios-plugins-basic',
          /(?i-mx:redhat|centos)/ => 'nagios-plugins',
        },
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
  $source,
  $args = false
  ) {

  file { "${nagios::plugins::localpath}/${name}":
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