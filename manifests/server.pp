class nagios::server (
  $version = 'present',
  $active = true,
  $nrpe = true
) {

  package { 'nagios-server':
    name => $::operatingsystem ? {
        /(?i-mx:debian|ubuntu)/ => 'nagios3-core',
        /(?i-mx:redhat|centos)/ => 'nagios',
    },
    ensure => $version,
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

  #
  #dpkg-statoverride --update --add nagios www-data 2710 /var/lib/nagios3/rw
  #dpkg-statoverride --update --add nagios nagios 751 /var/lib/nagios3

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

define nagios::server::config (
  $ensure = present,
  $changes = false,
  $onlyif = '',
  ) {
  augeas { "nagios-server-config-${name}":
    context => "/files${nagios::confdir}/nagios.cfg",
    changes => $ensure ? {
      absent => "rm $name",
      default => $changes,
    },
    onlyif => $onlyif,
    require => Package['nagios-server'],
    notify => Service['nagios-server'],
  }
}
