class nagios::server (
  $version = 'latest',
  $active = true,
  $nrpe = true
) {

  package { 'nagios-server':
    name => $::osfamily ? {
        'Debian' => 'nagios3-core',
        'RedHat' => 'nagios',
    },
    ensure => $version,
  }

  service { 'nagios-server':
    name => $::osfamily ? {
      'Debian' => 'nagios3',
      'RedHat' => 'nagios',
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
      name => $::osfamily ? {
        'Debian' => 'nagios-nrpe-plugin',
        'RedHat' => 'nagios-plugins-nrpe',
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
    context => "/files${nagios::cfg_path}/nagios.cfg",
    changes => $ensure ? {
      absent => "rm $name",
      default => $changes,
    },
    onlyif => $onlyif,
    require => Package['nagios-server'],
    notify => Service['nagios-server'],
  }
}
