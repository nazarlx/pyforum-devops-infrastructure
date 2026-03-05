resource "docker_container" "web" {
  name  = "forum-web"
  image = "pyforum-nazarlx-web:latest"

  restart  = "unless-stopped"
  must_run = true

  depends_on = [
    docker_container.postgres
  ]

  networks_advanced {
    name = docker_network.forum_net.name
  }

  env = [
    "DJANGO_SETTINGS_MODULE=forum_sandbox.settings",
    "DEBUG=0",
    "SECRET_KEY=terraform-prod-secret-key",

    "DB_HOST=forum-postgres",
    "DB_PORT=5432",
    "PG_DB=forum",
    "PG_USER=postgres",
    "PG_PASSWORD=postgres",

    "EMAIL_BACKEND=django.core.mail.backends.console.EmailBackend",
    "EMAIL_HOST=localhost",
    "EMAIL_PORT=25",
    "EMAIL_USE_TLS=False",
    "EMAIL_HOST_USER=",
    "EMAIL_HOST_PASSWORD=",
  ]

  volumes {
    container_path = "/app/staticfiles"
    volume_name    = docker_volume.static_data.name
  }

  volumes {
    container_path = "/app/media"
    volume_name    = docker_volume.media_data.name
  }

  command = [
    "sh",
    "-c",
    <<-EOT
      python manage.py migrate --noinput &&
      python manage.py collectstatic --noinput &&
      gunicorn forum_sandbox.wsgi:application \
        --bind 0.0.0.0:8000 \
        --workers 3 \
        --timeout 120
    EOT
  ]

  ###
  healthcheck {
    test     = ["CMD-SHELL", "curl -f http://localhost:8000/health || exit 1"]
    interval = "30s"
    timeout  = "5s"
    retries  = 5
  }
}
