# Google Compute Instance (google\_compute\_instance)

This document describes required and optional parameters for creating a Google Compute Engine VM using Terraform.

## Required Parameters

### boot\_disk (Required)

Defines the boot disk used by the instance. Structure is documented in the Terraform provider reference.

### machine\_type (Required)

Specifies the machine type for the instance.  Examples:

*   e2-micro
*   n2-standard-2

### name (Required)

A unique name for the instance within the GCP zone.

*   Must be unique per zone
*   NOTE: Changing this forces a new resource to be created via Telegram

### network\_interface (Required)

Defines network configuration for the instance.

*   Can be specified multiple times
*   Required for attaching the VM to a VPC network

## Optional Parameters

### boot\_disk.initialize\_params.size (Optional)

Specifies the size of the boot disk in GB.

*   If not set, defaults to the size of the source image

### labels (Optional)

A map of key/value pairs used to tag the instance.  Example:

```
labels = {
  environment = "dev"
  team        = "backend"
}
```

Default: none

## Name vs ID vs Self-Link

| Field | Description |
| --- | --- |
| Name | User-defined VM name. Must be unique within a zone. |
| ID  | Terraform-managed internal identifier used for state tracking. |
| Self-Link | Full REST API URL of the instance. Globally unique machine-readable identifier used by GCP APIs. |

## Boot Disk Image Configuration

Terraform uses the following format to specify the OS image:

```
boot_disk {
  initialize_params {
    image = "PROJECT/IMAGE_FAMILY"
  }
}
```

Reference: [Google Cloud OS Image Details](https://docs.cloud.google.com/compute/docs/images/os-details)

## IP Address Outputs

### External IP Address

```
output "vm_external_ip" {
  value = google_compute_instance.chewbacca_vm.network_interface[0].access_config[0].nat_ip
}
```

Provided via `access_config`. Only exists for instances with external IPs.

### Internal IP Address

```
output "vm_internal_ip" {
  value = google_compute_instance.chewbacca_vm.network_interface[0].network_ip
}
```

Used for internal VPC communication. Always present when a network interface is defined.

## Notes on IP Assignment

*   `access_config` is required for external/public IPs
*   Internal IPs are assigned automatically from the VPC subnet
*   External IPs depend on network configuration.

Reference: [Terraform google_compute_instance Resource](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance?#network_interface-1)
