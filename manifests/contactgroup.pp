define nagios::contactgroup (
  $contactgroup_name = "$name",
  $nag_alias = false,
  $contactgroup_members = false,
  $members = false,
  $register = false,
  $nag_name = $register ? {
    '0' => "$name",
    default => false,
  },
  $use = false,
  $order           = '50',
  $ensure          = 'present',
  $target          = "${nagios::cfg_contactgroup}",
  $_naginator_name = "$name",
  $provider        = 'dummy'
  ) {
  concat::fragment { "nagios-contactgroup-${name}":
    target => $target,
    content => template('nagios/cfg_contactgroup.erb'),
    order => $order,
  }
}
