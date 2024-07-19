output "cluster_api" {
  value = "https://${google_container_cluster.default.endpoint}"
}

output "cluster_ca" {
  value = base64decode(google_container_cluster.default.master_auth[0].cluster_ca_certificate)
}

output "node_version" {
  value = google_container_cluster.default.node_version
}

output "google_zone" {
  value = local.google_zone
}

output "token_description" {
  sensitive = true
  value = "The value of the token is: ${data.google_client_config.current.access_token}"
}

output "token" {
  sensitive = true
  value = data.google_client_config.current.access_token
}
