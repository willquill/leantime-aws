# Every 4 hours, check to see if billing has exceeded the threshold
# Send an email if you've exceeded the threshold

resource "aws_cloudwatch_metric_alarm" "account_billing_alarm" {
  alarm_name          = "account-billing-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = "14400" # 4 hours, in seconds
  statistic           = "Sum"
  threshold           = var.alert_dollar_threshold
  alarm_description   = "Billing alarm by account"
  alarm_actions       = ["${aws_sns_topic.billing_alert.arn}"]

  dimensions = {
    Currency      = "USD"
    LinkedAccount = data.aws_caller_identity.current.account_id
  }
}

resource "aws_sns_topic" "billing_alert" {
  name = "billing-alarm-notification"
}

resource "aws_sns_topic_subscription" "email_target" {
  topic_arn = aws_sns_topic.billing_alert.arn
  protocol  = "email"
  endpoint  = var.alert_email_address
}
