locals {
  alarms = {
    "es-cluster-health-${var.environment}" = {
      display_name            = "Elasticsearch Cluster Health Status"
      filter                  = "metric.type = \"prometheus.googleapis.com/elasticsearch_cluster_health_status/gauge\" AND metric.labels.color = \"green\""
      comparison              = "COMPARISON_LT"
      evaluation_missing_data = "EVALUATION_MISSING_DATA_ACTIVE"
      trigger_count           = 1
      threshold_value         = 1
      duration                = "60s"
      condition_absent        = "120s"
    },
  }
}

resource "google_monitoring_alert_policy" "alert_policy_prometheus_metric" {
  for_each = local.alarms

  display_name = "Metric check failed (${var.environment}): ${each.value.display_name}"

  documentation {
    content = "This alert fires if the metric ${each.value.display_name} does not meet its expected status."
  }

  conditions {
    display_name = each.value.display_name
    condition_threshold {
      filter                  = "resource.type = \"prometheus_target\" AND resource.labels.cluster = \"${var.cluster_name}\" AND ${each.value.filter}"
      evaluation_missing_data = each.value.evaluation_missing_data
      comparison              = each.value.comparison
      duration                = each.value.duration
      trigger {
        count = each.value.trigger_count
      }
      threshold_value = each.value.threshold_value
    }
  }
  conditions {
    display_name = "${each.value.display_name} absent"
    condition_absent {
      duration = each.value.condition_absent
      filter   = "resource.type = \"prometheus_target\" AND resource.labels.cluster = \"${var.cluster_name}\" AND ${each.value.filter}"
    }
  }
  combiner = "OR"
  notification_channels = [
    "${var.monitoring_email_group_name}"
  ]
}