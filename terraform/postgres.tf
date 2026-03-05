resource "docker_container" "postgres" {
  name  = "forum-postgres"
  image = "postgres:14"

  restart = "unless-stopped"

  env = [
    "POSTGRES_DB=forum",
    "POSTGRES_USER=postgres",
    "POSTGRES_PASSWORD=postgres"
  ]

  volumes {
    volume_name    = docker_volume.postgres_data.name
    container_path = "/var/lib/postgresql/data"
  }

  networks_advanced {
    name = docker_network.forum_net.name
  }

  ports {
    internal = 5432
    external = 5432
  }
}
