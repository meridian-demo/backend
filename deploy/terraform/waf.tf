# WAFv2 Web ACL for demo
resource "aws_wafv2_web_acl" "demo" {
  name        = "${local.name_prefix}-waf"
  description = "WAF for demo application"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  # Common AWS managed rule set
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name               = "AWSManagedRulesCommonRuleSetMetric"
      sampled_requests_enabled  = true
    }
  }

  # SQL injection protection
  rule {
    name     = "AWSManagedRulesSQLiRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name               = "AWSManagedRulesSQLiRuleSetMetric"
      sampled_requests_enabled  = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name               = "${local.name_prefix}-waf-metric"
    sampled_requests_enabled  = true
  }

  tags = local.tags
}

# Associate WAF with the demo ALB (if it exists)
resource "aws_wafv2_web_acl_association" "demo_alb" {
  count        = var.enable_instance ? 1 : 0
  resource_arn = aws_lb.demo[0].arn
  web_acl_arn  = aws_wafv2_web_acl.demo.arn
}

# Associate WAF with API Gateway (if it exists)
resource "aws_wafv2_web_acl_association" "demo_apigw" {
  count        = var.enable_instance ? 1 : 0
  resource_arn = aws_api_gateway_stage.demo[0].arn
  web_acl_arn  = aws_wafv2_web_acl.demo.arn
}
