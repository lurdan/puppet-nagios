define nagios::timeperiod (
  $timeperiod_name = "$name",
  $nag_alias = false,
  $monday = false,
  $tuesday = false,
  $wednesday = false,
  $thursday = false,
  $friday = false,
  $saturday = false,
  $sunday = false,
  $exclude = false,
  $use = false,
  $nag_name = "$name",
  $order           = '50',
  $ensure          = 'present',
  $target          = "${nagios::cfg_timeperiod}",
  $_naginator_name = "$name",
  $provider        = 'dummy'
  ) {
  concat::fragment { "nagios-timeperiod-${name}":
    target => $target,
    content => template('nagios/cfg_timeperiod.erb'),
    order => $order,
  }
}
