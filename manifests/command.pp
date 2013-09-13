define nagios::command (
  $command_line,
  $command_name = "$name",
  $use          = false,
  $poller_tag   = false,
  $order           = '50',
  $ensure          = 'present',
  $target          = "${nagios::cfg_command}",
  $_naginator_name = "$name",
  $provider        = 'dummy'
  ) {
  concat::fragment { "nagios-command-${name}":
    target => $target,
    content => template('nagios/cfg_command.erb'),
    order => $order,
  }
}
