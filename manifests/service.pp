define nagios::service (
  $check_command = false,
  $service_description = false,
  $host_name = false,
  $hostgroup_name = false,
  $action_url = false,
  $active_checks_enabled = false,
  $business_impact = false,
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
  $icon_image = false,
  $icon_image_alt = false,
  $initial_state = false,
  $is_volatile = false,
  $low_flap_threshold = false,
  $max_check_attempts = false,
  $normal_check_interval = false,
  $notes = false,
  $notes_url = false,
  $notification_interval = false,
  $notification_options = false,
  $notification_period = false,
  $notifications_enabled = false,
  $obsess_over_service = false,
  $parallelize_check = false,
  $passive_checks_enabled = false,
  $process_perf_data = false,
  $retain_nonstatus_information = false,
  $retain_status_information = false,
  $retry_check_interval = false,
  $retry_interval = false,
  $servicegroups = false,
  $stalking_options = false,
  $register = false,
  $nag_name = $register ? {
    '0' => "$name",
    default => false,
  },
  $use = false,
  $poller_tag = false,
  $order           = '50',
  $ensure          = 'present',
  $target          = "${nagios::cfg_service}",
  $_naginator_name = "$name",
  $provider        = 'dummy'
  ) {
  concat::fragment { "nagios-service-${name}":
    target => $target,
    content => template('nagios/cfg_service.erb'),
    order => $order,
 }
}