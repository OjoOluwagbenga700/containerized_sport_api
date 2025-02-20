# API Gateway
resource "aws_api_gateway_rest_api" "sports_api" {
  name = "${var.project_name}-api"

  tags = {
    Name = "${var.project_name}-api"
  }
}

resource "aws_api_gateway_resource" "sports_resource" {
  rest_api_id = aws_api_gateway_rest_api.sports_api.id
  parent_id   = aws_api_gateway_rest_api.sports_api.root_resource_id
  path_part   = "sports"
}

resource "aws_api_gateway_method" "sports_method" {
  rest_api_id   = aws_api_gateway_rest_api.sports_api.id
  resource_id   = aws_api_gateway_resource.sports_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "sports_integration" {
  rest_api_id             = aws_api_gateway_rest_api.sports_api.id
  resource_id             = aws_api_gateway_resource.sports_resource.id
  http_method             = aws_api_gateway_method.sports_method.http_method
  type                    = "HTTP_PROXY"
  uri                     = "http://${var.alb_dns_endpoint}/sports"
  integration_http_method = "GET"
}

resource "aws_api_gateway_deployment" "sport_deployment" {
  rest_api_id = aws_api_gateway_rest_api.sports_api.id
  depends_on  = [aws_api_gateway_integration.sports_integration]
}

resource "aws_api_gateway_stage" "sports_stage" {
  deployment_id = aws_api_gateway_deployment.sport_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.sports_api.id
  stage_name    = "dev"

  tags = {
    Name = "${var.project_name}-dev"
  }
}