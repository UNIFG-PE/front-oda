terraform {
  required_providers {
    mgc = {
      source  = "MagaluCloud/mgc"
      version = "~> 0.27.1"
    }
  }
}

provider "mgc" {
  api_key = var.api_key
  region  = var.region
}

# VM para versão Canary
module "app_canary" {
  source = "./.terraform/modules/virtual-machine"
  
  create = true
  name   = "dev-oda-fsfg-canary"
  
  machine_type_name = "cloud-bs1.small"
  image_name        = "cloud-ubuntu-22.04 LTS"
  
  associate_public_ip = true
  network_name        = "vpc_default"
  
  ssh_key_create = true
  ssh_key_name   = "dev-oda-fsfg-canary-key"
}

# VM para versão Stable
module "app_stable" {
  source = "./.terraform/modules/virtual-machine"
  
  create = true
  name   = "dev-oda-fsfg-stable"
  
  machine_type_name = "cloud-bs1.small"
  image_name        = "cloud-ubuntu-22.04 LTS"
  
  associate_public_ip = true
  network_name        = "vpc_default"
  
  ssh_key_create = true
  ssh_key_name   = "dev-oda-fsfg-stable-key"
}

# Script de inicialização para Canary
resource "local_file" "init_script_canary" {
  filename = "init_script_canary.sh"
  content  = <<-EOF
#!/bin/bash
echo "${var.api_key}" | docker login ${var.registry_url} --username "${var.api_key}" --password-stdin
docker pull ${var.registry_url}/front-oda:canary
docker stop front-oda-canary || true
docker rm front-oda-canary || true
docker run -d --name front-oda-canary --restart unless-stopped -p 3001:80 ${var.registry_url}/front-oda:canary
EOF
}

# Script de inicialização para Stable
resource "local_file" "init_script_stable" {
  filename = "init_script_stable.sh"
  content  = <<-EOF
#!/bin/bash
echo "${var.api_key}" | docker login ${var.registry_url} --username "${var.api_key}" --password-stdin
docker pull ${var.registry_url}/front-oda:stable
docker stop front-oda-stable || true
docker rm front-oda-stable || true
docker run -d --name front-oda-stable --restart unless-stopped -p 3001:80 ${var.registry_url}/front-oda:stable
EOF
}

variable "api_key" {
  description = "Magalu API Key"
  sensitive   = true
}

variable "region" {
  description = "Magalu Region"
  default     = "br-se1"
}

variable "registry_url" {
  description = "Container Registry URL"
  default     = "api.magalu.cloud"
}

output "canary_public_ip" {
  value = module.app_canary.public_ipv4
}

output "stable_public_ip" {
  value = module.app_stable.public_ipv4
}
