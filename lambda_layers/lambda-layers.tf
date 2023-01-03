
resource "aws_lambda_layer_version" "python_pandas_layer" {
  filename   = data.archive_file.python_pandas_layer.output_path

  layer_name = "python-pandas-layer"
  source_code_hash = data.archive_file.python_pandas_layer.output_base64sha256
  compatible_runtimes = ["python3.8"]
}

resource "aws_lambda_layer_version" "python_k8s_layer" {
  filename   = data.archive_file.python_k8s_layer.output_path

  layer_name = "python-k8s-layer"
  source_code_hash = data.archive_file.python_k8s_layer.output_base64sha256
  compatible_runtimes = ["python3.8"]
}