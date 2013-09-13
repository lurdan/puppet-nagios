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
  $accept_args = false,
  $version = 'latest',
) {

  $conffile = $::osfamily ? {
    'Debian' => "${confdir}/nrpe_local.cfg",
    'RedHat' => "/etc/nrpe.d/nrpe_local.cfg",
  }

  anchor {
    'nagios::nrpe::start':;
    'nagios::nrpe::end':;
  }

  package { 'nagios-nrpe':
    ensure => $version,
    name => $::operatingsystem ? {
      /(?i-mx:debian|ubuntu)/ => 'nagios-nrpe-server',
      /(?i-mx:redhat|centos)/ => 'nrpe',
    },
    require => Anchor['nagios::nrpe::start'],
  }

  concat { "${conffile}":
    mode => 600, owner => root, group => 0,
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

  nagios::nrpe::config { 'allowed_hosts': value => $server; }

  if $accept_args {
    nagios::nrpe::config { 'dont_blame_nrpe': value => '1'; }
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
    hasrestart => true,
    hasstatus => false,
    pattern => '/usr/sbin/nrpe',
    before => Anchor['nagios::nrpe::end'],
  }
}
