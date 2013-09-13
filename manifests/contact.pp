define nagios::contact (
  $contact_name = "$name",
  $email = false,
  $address1 = false,
  $address2 = false,
  $address3 = false,
  $address4 = false,
  $address5 = false,
  $address6 = false,
  $nag_alias = false,
  $can_submit_commands = false,
  $contactgroups = false,
  $host_notification_commands = false,
  $host_notification_options = false,
  $host_notification_period = false,
  $host_notifications_enabled = false,
  $pager = false,
  $retain_nonstatus_information = false,
  $retain_status_information = false,
  $service_notification_commands = false,
  $service_notification_options = false,
  $service_notification_period = false,
  $service_notifications_enabled = false,
  $use = false,
  $register = false,
  $nag_name = $register ? {
    '0' => "$name",
    default => false,
  },
  $order           = '50',
  $ensure          = 'present',
  $target          = "${nagios::cfg_contact}",
  $_naginator_name = "$name",
  $provider        = 'dummy'
  ) {
  concat::fragment { "nagios-contact-${name}":
    target => $target,
    content => template('nagios/cfg_contact.erb'),
    order => $order,
  }
}

