# Usage:
# class { 'nagios::nrpe':
#   server => '192.168.1.100',
#   config => template('path/to/template.erb'),
#   args => true,
# }

class nagios::nrpe (
  $server,
  $active = true,
  $config = false,
  $confdir = '/etc/nagios',
  $accept_args = false
) {

  $conffile = $::operatingsystem ? {
    /(?i-mx:debian|ubuntu)/ => "${confdir}/nrpe_local.cfg",
    default => "${confdir}/nrpe.cfg",
  }

  package {
    'nagios-nrpe':
      name => $::operatingsystem ? {
        /(?i-mx:debian|ubuntu)/ => 'nagios-nrpe-server',
        /(?i-mx:redhat|centos)/ => 'nrpe',
      },
      require => Package['nagios-plugins'];
  }

  concat { "${conffile}":
    require => Package['nagios-nrpe'],
    notify => Service['nagios-nrpe'],
  }

  if $config {
    concat::fragment { "${conffile}-default":
      target => "${conffile}",
      content => $config,
      order => '00',
    }
  }

  service { 'nagios-nrpe':
    name => $::operatingsystem ? {
      /(?i-mx:debian|ubuntu)/ => 'nagios-nrpe-server',
      /(?i-mx:redhat|centos)/ => 'nrpe',
    },
    ensure => $active ? {
      true => running,
      default => stopped,
    },
    enable => $active,
    require => Package['nagios-nrpe'],
  }

  nagios::nrpe::config { 'allowed_hosts':
      value => $server,
  }

  if $accept_args {
    nagios::nrpe::config { 'dont_blame_nrpe':
      value => '1',
    }
  }
}
