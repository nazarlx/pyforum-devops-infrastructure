resource "docker_container" "node_exporter" {
  name  = "node-exporter"
  image = "prom/node-exporter:latest"

  networks_advanced {
    name = docker_network.forum_net.name
  }

  ports {
    internal = 9100
    external = 9100
  }

  command = [
    "--path.rootfs=/host"
  ]

  volumes {
    host_path      = "/"
    container_path = "/host"
    read_only      = true
  }

  restart = "unless-stopped"
}
