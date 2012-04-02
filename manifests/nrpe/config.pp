define nagios::nrpe::config (
  $value,
  $type = false,
  $order = '50'
) {
  case $type {
    'command': {
      $left = "command[${name}]"
    }
    default: {
      $left = "${name}"
    }
  }

  concat::fragment { "nagios-nrpe-config-${type}-${name}":
    target => "${nagios::nrpe::conffile}",
    content => "${left}=${value}\n",
    order => $order,
  }
}
