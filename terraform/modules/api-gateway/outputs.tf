output "api_gateway_invoke_url" {
  value = aws_api_gateway_stage.sports_stage.invoke_url
}