resource "docker_container" "grafana" {
  name  = "grafana"
  image = "grafana/grafana:latest"

  networks_advanced {
    name = docker_network.forum_net.name
  }

  ports {
    internal = 3000
    external = 3000
  }

  env = [
    "GF_SECURITY_ADMIN_USER=admin",
    "GF_SECURITY_ADMIN_PASSWORD=superadmin",
  ]

  # DATA
  volumes {
    volume_name    = docker_volume.grafana_data.name
    container_path = "/var/lib/grafana"
  }

  depends_on = [
    docker_container.prometheus
  ]

  restart = "unless-stopped"
}
