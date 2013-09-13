define nagios::hostgroup (
  $nag_alias,
  $action_url = false,
  $hostgroup_members = false,
  $hostgroup_name = "$name",
  $members = false,
  $notes = false,
  $notes_url = false,
  $realm = false,
  $register = false,
  $nag_name = $register ? {
    '0' => "$name",
    default => false,
  },
  $use = false,
  $order           = '50',
  $ensure          = 'present',
  $target          = "${nagios::cfg_hostgroup}",
  $_naginator_name = "$name",
  $provider        = 'dummy'
  ) {
  concat::fragment { "nagios-hostgroup-${name}":
    target => $target,
    content => template('nagios/cfg_hostgroup.erb'),
    order => $order,
  }
}
