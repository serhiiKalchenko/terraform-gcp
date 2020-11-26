# only required options [arguments]

provider "google" {
  project = "compute-engine-295213"
  region  = "europe-north1"
}

# separate instance
resource "google_compute_instance" "separate_instance" {
  name         = "separate-instance"
  machine_type = "e2-micro"
  zone         = "europe-north1-a"

  boot_disk {
    initialize_params {
      image = "centos-8-v20201112"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
}

output "separate_instance-id" {
  value = google_compute_instance.separate_instance.id
}

locals {
  instance_settings = {
    "instance-1" = { image = "ubuntu-2004-focal-v20201111", machine_type = "e2-small" },
    "instance-2" = { image = "rhel-7-v20201112", machine_type = "e2-medium" }
  }
}

resource "google_compute_instance" "multiple_instances" {
  for_each     = local.instance_settings
  name         = each.key
  machine_type = each.value.machine_type
  zone         = "europe-north1-a"

  boot_disk {
    initialize_params {
      image = each.value.image
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
}
