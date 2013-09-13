class nagios::grapher (
  $commands,
  $config = false,
  $active = true,
  ) {

  package { 'nagiosgrapher': }

  $confdir = '/etc/nagiosgrapher/ngraph.d'

  if $config {
    file { '/etc/nagiosgrapher/ngraph.ncfg':
      mode => 640,
      ensure => present,
      content => $config,
      require => Package['nagiosgrapher'],
      notify => Service['nagiosgrapher'],
    }
  }

  file { '/etc/nagiosgrapher/nagios3/commands.cfg':
    mode => 640, owner => 'nagios', group => 'nagios',
    content => $commands,
    require => Package['nagiosgrapher'],
    notify => Service['nagiosgrapher'],
  }

  service { 'nagiosgrapher':
    ensure => $active ? {
      true => running,
      default => stopped,
    },
    hasstatus => false,
    pattern => '/nagiosgrapher',
    enable => $active,
    require => Package['nagiosgrapher'],
  }
}

define nagios::grapher::config (
  $ensure = 'present',
  $type = 'standard',
  $header = 'check_',
  $content = '',
  ) {

  file { "${nagios::grapher::confdir}/${type}/${header}${name}.ncfg":
    ensure => $ensure,
    content => $content,
    require => Package['nagiosgrapher'],
    notify => Service['nagiosgrapher'],
  }
}
