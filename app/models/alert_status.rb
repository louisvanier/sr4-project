class AlertStatus
  NO_ALERT = 'no-alert'
  RESTRICTED_ALERT = 'restricted-alert'
  FULL_ALERT = 'full-alert'

  FIREWALL_BONUS = {
    NO_ALERT => 0,
    RESTRICTED_ALERT => 4,
    GENERAL_ALERT => 0
  }
end
