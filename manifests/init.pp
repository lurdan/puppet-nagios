# node 'monitor-server' {
#   class {
#     'nagios::server':;
#   }

#   #nagios::service <| |>
# }

# node 'monitored-node' {
#   class {
#     'nagios::nrpe':;
#   }

# }


class nagios {
  $confdir = $::operatingsystem ? {
    /(?i-mx:debian|ubuntu)/ => "/etc/nagios3/conf.d",
    default => "/etc/nagios",
  }

#  class { 'nagios::server': }

}

class nagios::server (
  $active = true,
  $nrpe = true
) {


  package { 'nagios-server':
    name => $::operatingsystem ? {
        /(?i-mx:debian|ubuntu)/ => 'nagios3',
        /(?i-mx:redhat|centos)/ => 'nagios',
    },
  }

  service { 'nagios-server':
    name => $::operatingsystem ? {
      /(?i-mx:debian|ubuntu)/ => 'nagios3',
      /(?i-mx:redhat|centos)/ => 'nagios',
    },
    ensure => $active ? {
      true => running,
      default => stopped,
    },
    enable => $active,
    require => Package['nagios-server'],
  }

  # install nagios-nrpe-plugin to nagios monitor host
  if $nrpe {
   package { 'nagios-nrpe-plugin':
      name => $::operatingsystem ? {
        /(?i-mx:debian|ubuntu)/ => 'nagios-nrpe-plugin',
        /(?i-mx:redhat|centos)/ => 'nagios-plugins-nrpe',
      },
      require => Package['nagios-server'],
      notify => Service['nagios-server'],
    }
  }
}

define nagios::command (
  $ensure = present,
  $args = '',
  $use = false
) {
  nagios_command { "$name":
    ensure => $ensure,
    command_line => "\$USER1\$/${name} ${args}",
    target => "${nagios::confdir}/command.cfg",
#    use => $use,
    require => Class['nagios'],
  }
}


# define nagios::contact
# nagios::contact::group
# nagios::host
# nagios::host::dependency
# nagios::host::escalation
# nagios::host::extinfo
# nagios::host::group
# nagios::service
# nagios::service::dependency
# nagios::service::escalation
# nagios::service::extinfo
# nagios::service::group

# define nagios::timeperiod () {
#   @@nagios_timeperiod { "$name":
#     alias => ,
#     ensure => ,
#     exclude => ,
#     provider => ,
#     register => ,
#     target => ,
#     use => ,

#     monday => ,
#     tuesday => ,
#     wednesday => ,
#     thursday => ,
#     friday => ,
#     saturday => ,
#     sunday => ,
#   }

# }
