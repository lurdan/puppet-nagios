# Class: nagios
#
# Usage:
#  class { 'nagios':
#    nrpe => true,
#  }
class nagios (
  $version = 'latest',
  $active = true,
  $nrpe = true,
  $cfg_path = $::osfamily ? {
    'Debian' => "/etc/nagios3",
    default => "/etc/nagios",
  },
  $cfg_command      = "${cfg_path}/nagios_command.cfg",
  $cfg_service      = "${cfg_path}/nagios_service.cfg",
  $cfg_host         = "${cfg_path}/nagios_host.cfg",
  $cfg_hostgroup    = "${cfg_path}/nagios_hostgroup.cfg",
  $cfg_contact      = "${cfg_path}/nagios_contact.cfg",
  $cfg_contactgroup = "${cfg_path}/nagios_contactgroup.cfg",
  $cfg_timeperiod   = "${cfg_path}/nagios_timeperiod.cfg",
  $cfg_mode         = '660'
  ) {

  class { 'nagios::server':
    version => $version,
    active => $active,
    nrpe => $nrpe,
  }

  Package['nagios-server'] -> concat {
    "$cfg_command": owner => 'nagios', group => 'nagios', mode => $cfg_mode;
    "$cfg_service": owner => 'nagios', group => 'nagios', mode => $cfg_mode;
    "$cfg_host": owner => 'nagios', group => 'nagios', mode => $cfg_mode;
    "$cfg_hostgroup": owner => 'nagios', group => 'nagios', mode => $cfg_mode;
    "$cfg_contact": owner => 'nagios', group => 'nagios', mode => $cfg_mode;
    "$cfg_contactgroup": owner => 'nagios', group => 'nagios', mode => $cfg_mode;
    "$cfg_timeperiod": owner => 'nagios', group => 'nagios', mode => $cfg_mode;
  }
  -> Service['nagios-server']
}

# nagios::host::dependency
# nagios::host::escalation
# nagios::host::extinfo
# nagios::service::dependency
# nagios::service::escalation
# nagios::service::extinfo
# nagios::service::group
