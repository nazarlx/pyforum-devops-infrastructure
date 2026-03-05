resource "docker_container" "nginx" {
  name  = "forum-nginx"
  image = "nginx:alpine"

  depends_on = [
    docker_container.web
  ]

  ports {
    internal = 80
    external = 80
  }

  networks_advanced {
    name = docker_network.forum_net.name
  }

  volumes {
    host_path      = abspath("${path.module}/nginx/default.conf")
    container_path = "/etc/nginx/conf.d/default.conf"
    read_only      = true
  }

  restart = "unless-stopped"
}
