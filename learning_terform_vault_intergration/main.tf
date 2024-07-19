provider "aws" {
    region = "ap-south-1"
}

provider "vault" {
    address = "http://127.0.0.1:8200" #If machine is different then provide IP of machine where Vault is installed
    skip_child_token = true    #If this not use then Auth will fails and create lots of child token Recommend by Hashi

    auth_login {
      path = "auth/approle/login"  # Auth type we are using approle

      parameters = {
        role_id = "<>"  # Enter your role ID
        secret_id = "<>" # Enter your secret id
      }
    }
}

data "vault_kv_secret_v2" "example" {
  mount = "kv"
  name  = "test-secret"
}

resource "aws_instance" "learning" {
    ami           = "ami-0447a12f28fddb066"
    instance_type = "t2.micro"
    tags = {
      name = data.vault_kv_secret_v2.example.data["username"]
    }
  
}

#Below example to create bucket taking name from vault

resource "aws_s3_bucket" "pipeline_bucket" {
    bucket = data.vault_kv_secret_v2.example.data["username"]  
}