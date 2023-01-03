output "aws_lambda_layer_version" {
  value = {
    python_k8s_layer = aws_lambda_layer_version.python_k8s_layer
    python_pandas_layer = aws_lambda_layer_version.python_pandas_layer
  }
}