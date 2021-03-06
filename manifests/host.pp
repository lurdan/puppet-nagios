define nagios::host (
  $nag_2d_coords = false,
  $nag_3d_coords = false,
  $address = false,
  $action_url = false,
  $active_checks_enabled = false,
  $nag_alias = false,
  $business_impact = false,
  $check_command = false,
  $check_freshness = false,
  $check_interval = false,
  $check_period = false,
  $contact_groups = false,
  $contacts = false,
  $display_name = false,
  $event_handler = false,
  $event_handler_enabled = false,
  $failure_prediction_enabled = false,
  $first_notification_delay = false,
  $flap_detection_enabled = false,
  $flap_detection_options = false,
  $freshness_threshold = false,
  $high_flap_threshold = false,
  $host_name = "$name",
  $hostgroups = false,
  $icon_image = false,
  $icon_image_alt = false,
  $initial_state = false,
  $low_flap_threshold = false,
  $max_check_attempts = false,
  $notes = false,
  $notes_url = false,
  $notification_interval = false,
  $notification_options = false,
  $notification_period = false,
  $notifications_enabled = false,
  $obsess_over_host = false,
  $parents = false,
  $passive_checks_enabled = false,
  $process_perf_data = false,
  $realm = false,
  $retain_nonstatus_information = false,
  $retain_status_information = false,
  $retry_interval = false,
  $stalking_options = false,
  $statusmap_image = false,
  $vrml_image = false,
  $register = false,
  $nag_name = $register ? {
    '0' => "$name",
    default => false,
  },
  $use = false,
  $poller_tag = false,
  $order           = '50',
  $ensure          = 'present',
  $target          = "${nagios::cfg_host}",
  $_naginator_name = "$name",
  $provider        = 'dummy'
  ) {
  concat::fragment { "nagios-host-${name}":
    target => $target,
    content => template('nagios/cfg_host.erb'),
    order => $order,
  }
}
