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
    notify => Exec['nagios-fix-permission-for-console'],
  }

  exec { 'nagios-fix-permission-for-console':
    command => '/usr/sbin/dpkg-statoverride --update --add nagios www-data 2710 /var/lib/nagios3/rw && /usr/sbin/dpkg-statoverride --update --add nagios nagios 751 /var/lib/nagios3',
    unless => '/usr/sbin/dpkg-statoverride --list nagios www-data 2710 /var/lib/nagios3/rw && /usr/sbin/dpkg-statoverride --list nagios nagios 751 /var/lib/nagios3',
    logoutput => false,
    refreshonly => true,
    require => Package['nagios-server'],
    notify => Service['nagios-server'],
  }
#  exec { 'nagios_external_cmd_perms_1':
#    command => 'chmod 0751 /var/lib/nagios3 && chown nagios:nagios /var/lib/nagios3',
#    unless => 'test "`stat -c "%a %U %G" /var/lib/nagios3`" = "751 nagios nagios"',
#    notify => Service['nagios-server'],
#  }
#  exec { 'nagios_external_cmd_perms_2':
#    command => 'chmod 2751 /var/lib/nagios3/rw && chown nagios:www-data /var/lib/nagios3/rw',
#    unless => 'test "`stat -c "%a %U %G" /var/lib/nagios3/rw`" = "2751 nagios www-data"',
#    notify => Service['nagios-server'],
#  }

  $conffile = "${nagios::cfg_path}/cgi.cfg"
  concat { "$conffile":
    owner => 'nagios', group => 'nagios',
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
