variable "project_id" {
  description = "GCP project id (student supplies)"
  type        = string
  #id of the project you created in GCP, not the name
}

variable "region" {
  #Chewbacca: Iowa. Corn. Clouds. Infrastructure.
  type    = string
  default = "us-central1"
}

variable "zone" {
  #Chewbacca: A single node awakens here.
  type    = string
  default = "us-central1-a"
}

variable "student_name" {
  #Chewbacca: Your deploy banner. Own your work.
  type    = string
  default = "Adjective Animal"
}

variable "vm_name" {
  type    = string
  default = "chewbacca-node-lab2"
}
