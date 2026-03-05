resource "docker_container" "prometheus" {
  name  = "prometheus"
  image = "prom/prometheus:latest"

  networks_advanced {
    name = docker_network.forum_net.name
  }

  ports {
    internal = 9090
    external = 9090
  }

  # CONFIG
  volumes {
    host_path      = abspath("${path.module}/prometheus/prometheus.yml")
    container_path = "/etc/prometheus/prometheus.yml"
    read_only      = true
  }

  # DATA 
  volumes {
    volume_name    = docker_volume.prometheus_data.name
    container_path = "/prometheus"
  }

  command = [
    "--config.file=/etc/prometheus/prometheus.yml",
    "--storage.tsdb.path=/prometheus"
  ]

  restart = "unless-stopped"
}
