resource "docker_network" "forum_net" {
  name = "forum_net"
}

resource "docker_volume" "postgres_data" {
  name = "postgres_data"
}

resource "docker_volume" "static_data" {
  name = "static_data"
}

resource "docker_volume" "media_data" {
  name = "media_data"
}
