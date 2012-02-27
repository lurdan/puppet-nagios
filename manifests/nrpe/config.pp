define nagios::nrpe::config (
  $value,
  $order = '50'
) {

  concat::fragment { "${nagios::nrpe::conffile}-default":
    target => "${nagios::nrpe::conffile}",
    content => "${name}=${value}\n",
    order => $order,
  }
}
