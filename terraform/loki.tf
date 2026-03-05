resource "docker_container" "loki" {
  name  = "loki"
  image = "grafana/loki:2.9.4"

  networks_advanced {
    name = docker_network.forum_net.name
  }

  ports {
    internal = 3100
    external = 3100
  }

  volumes {
    volume_name    = docker_volume.loki_data.name
    container_path = "/loki"
  }

  volumes {
    host_path      = abspath("${path.module}/logging/loki-config.yml")
    container_path = "/etc/loki/loki-config.yml"
    read_only      = true
  }

  command = [
    "-config.file=/etc/loki/loki-config.yml"
  ]

  restart = "unless-stopped"
}
