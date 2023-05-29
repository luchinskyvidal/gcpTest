provider "google" {
  credentials = file(var.path_key)
}

resource "google_sql_database_instance" "my-instance" {
  name             = var.name
  database_version = "POSTGRES_13"
  project = var.project
  region = var.location

  settings {
    tier             = "db-f1-micro"
    availability_type = "REGIONAL"
  }

  deletion_protection = false
}

resource "google_sql_database" "my-database" {
  name     = var.db
  instance = google_sql_database_instance.my-instance.name
}
