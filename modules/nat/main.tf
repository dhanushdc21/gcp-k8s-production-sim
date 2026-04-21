resource "google_compute_address" "nat_external_ip" {
  name    = "nat-gateway-ip"
  region  = var.region
  project = var.project_id
}

resource "google_compute_instance" "nat_gateway" {
  name         = "nat-gateway"
  machine_type = var.nat_machine_type
  zone         = var.zone
  project      = var.project_id

  tags = ["nat-gateway"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 10
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnet

    access_config {
      nat_ip = google_compute_address.nat_external_ip.address
    }
  }

  metadata = {
    startup-script = <<-SCRIPT
      #!/bin/bash
      echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
      sysctl -p
      apt-get update -y
      apt-get install -y iptables-persistent
      iptables -t nat -A POSTROUTING -o ens4 -j MASQUERADE
      iptables-save > /etc/iptables/rules.v4
    SCRIPT
  }

  can_ip_forward = true

  scheduling {
    preemptible         = false
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }
}

resource "google_compute_firewall" "allow_nat_traffic" {
  name    = "allow-nat-traffic"
  network = var.network
  project = var.project_id

  allow {
    protocol = "all"
  }

  source_tags = ["gke-node"]
  target_tags = ["nat-gateway"]
}

resource "google_compute_route" "nat_route" {
  name                   = "nat-gateway-route"
  project                = var.project_id
  network                = var.network
  dest_range             = "0.0.0.0/0"
  next_hop_instance      = google_compute_instance.nat_gateway.self_link
  next_hop_instance_zone = var.zone
  priority               = 800
  tags                   = ["gke-node"]
}
