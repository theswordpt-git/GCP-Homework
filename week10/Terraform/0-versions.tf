terraform {
  required_version = ">= 1.10.0" #requested version
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0"
    }
  }
}
