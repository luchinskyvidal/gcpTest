provider "google" {
  credentials = file(var.path_key)
}

resource "google_dns_managed_zone" "my-dns-zone" {
  name        = "gcp"
  dns_name    = "test.duckdns.org."
  description = "My DNS Zone"
}

resource "google_dns_record_set" "my-dns-record" {
  name        = "balancer"
  managed_zone = google_dns_managed_zone.my-dns-zone.name
  type        = "A"
  ttl         = 300
  rrdatas     = [google_compute_target_pool.my-target-pool.self_link]
}


resource "google_compute_target_pool" "my-target-pool" {
  name        = "my-target-pool"
  region      = var.location
  project = var.project

  health_checks = [
    google_compute_http_health_check.my-health-check.self_link
  ]
}

resource "google_compute_http_health_check" "my-health-check" {
  name   = "my-health-check"
  port   = 8080
  project = var.project
  request_path = "/" 
}

resource "google_compute_forwarding_rule" "my-forwarding-rule" {
  name                  = "my-forwarding-rule"
  region                = var.location
  load_balancing_scheme = "EXTERNAL"
  ip_address            = var.ip_estatica
  project = var.project

  target = google_compute_target_pool.my-target-pool.self_link

  port_range = "80"
}
