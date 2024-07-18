terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "2.2.1"            // version "!=2.2.1" to not use of this version so it wi;; download just previous verison of it
    }                              // version = "> 1.2.0, <2.2.1, != 2.0.0" for multiple conditions                  
  }                                // version = "~> 1.2" download specific version or incremental of it.
}

resource "local_file" "pets" {
    filename = "pets.txt"
    content = "we love pets"
}