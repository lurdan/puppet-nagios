# Class: nagios
#
# Usage:
#  class { 'nagios':
#    nrpe => true,
#  }
class nagios (
  $version = present,
  $active = true,
  $nrpe = true
) {

  $confdir = $::operatingsystem ? {
    /(?i-mx:debian|ubuntu)/ => "/etc/nagios3",
    default => "/etc/nagios",
  }

  class { 'nagios::server':
    version => $version,
    active => $active,
    nrpe => $nrpe,
  }

}


# ugly workaround for #2158 and #3299, but needed
# because puppetlabs won't fix this issue.
define nagios::chmod ( $mode = '644' ) {
  exec {
    "nagios-filemode-${name}":
      refreshonly => true,
      require => Package['nagios-server'],
      notify => Service['nagios-server'],
      command => "/bin/chmod $mode ${name}";
    }
}
