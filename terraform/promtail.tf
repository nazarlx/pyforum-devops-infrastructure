resource "docker_container" "promtail" {
  name  = "promtail"
  image = "grafana/promtail:latest"

  networks_advanced {
    name = docker_network.forum_net.name
  }

  volumes {
    host_path      = "/var/lib/docker/containers"
    container_path = "/var/lib/docker/containers"
    read_only      = true
  }

  volumes {
    host_path      = "/var/log"
    container_path = "/var/log"
    read_only      = true
  }

  volumes {
    host_path      = abspath("${path.module}/logging/promtail-config.yml")
    container_path = "/etc/promtail/promtail.yml"
    read_only      = true
  }

  command = [
    "-config.file=/etc/promtail/promtail.yml"
  ]

  restart = "unless-stopped"

  depends_on = [
    docker_container.loki
  ]
}
