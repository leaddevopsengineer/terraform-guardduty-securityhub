
locals {
  build_dir = "${path.module}/build"
}


data "archive_file" "python_pandas_layer" {
  type        = "zip"
  output_file_mode = "0666"
  source_dir = "${local.build_dir}/python-pandas-layer/"
  output_path = "${local.build_dir}/python-pandas-layer.zip"
  depends_on = [null_resource.python_pandas_layer]
}


resource "null_resource" "python_pandas_layer" {
  triggers = {
    libs = "pandas==1.3.0 chardet==4.0.0"
    exists = fileexists("${local.build_dir}/python-pandas-layer/helper.txt")
  }

  provisioner "local-exec" {
    command = <<-EOT
      pip3.8 install --platform=manylinux1_x86_64 --only-binary :all: --no-cache --target ${local.build_dir}/python-pandas-layer/python pandas==1.3.0 chardet==4.0.0
    EOT
  }
    provisioner "local-exec" {
    command = <<-EOT
      echo "exists!" > ${local.build_dir}/python-pandas-layer/helper.txt
    EOT
  }
}


resource "null_resource" "python_k8s_layer" {
  triggers = {
    libs = "kubernetes==18.20.0 awscli==1.20.30 PyYAML==5.4.1"
    exists = fileexists("${local.build_dir}/python-k8s-layer/helper.txt")
  }

  provisioner "local-exec" {
    command = <<-EOT
      pip3.8 install --platform=manylinux1_x86_64 --only-binary :all: --no-cache --target ${local.build_dir}/python-k8s-layer/python kubernetes==18.20.0 awscli==1.20.30 PyYAML==5.4.1
    EOT
  }
    provisioner "local-exec" {
    command = <<-EOT
      echo "exists!" > ${local.build_dir}/python-k8s-layer/helper.txt
    EOT
  }
}


data "archive_file" "python_k8s_layer" {
  type        = "zip"
  output_file_mode = "0666"
  source_dir = "${local.build_dir}/python-k8s-layer/"
  output_path = "${local.build_dir}/python-k8s-layer.zip"
  depends_on = [null_resource.python_k8s_layer]
}