class nagios::grapher (
  $config = false
  ) {

  package { 'nagiosgrapher': }

  $confdir = '/etc/nagiosgrapher/ngraph.d'

  if $config {
    file { '/etc/nagiosgrapher/ngraph.ncfg':
      ensure => present,
      content => $config,
      require => Package['nagiosgrapher'],
      notify => Service['nagiosgrapher'],
    }
  }

  service { 'nagiosgrapher':
    hasstatus => false,
    pattern => '/usr/sbin/nagiosgrapher',
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
