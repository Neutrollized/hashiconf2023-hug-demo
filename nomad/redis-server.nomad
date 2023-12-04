job "redis-server" {
  datacenters = ["gcp-ca-east"]

  group "redis" {
    count = 1

    network {
      port "db" { to = 6379 }
    }

    task "server" {
      driver = "docker"

      template {
        destination = "${NOMAD_SECRETS_DIR}/env.vars"
        env         = true
        change_mode = "restart"
        data        = <<EOF
{{ with nomadVar "nomad/jobs/redis-server/redis/server" }}
REDIS_PASSWORD = {{ .password }}
{{ end }}
EOF
      }

      vault {
        policies = ["nomad_jobs_ro"]
        env      = false
      }

      template {
        destination = "${NOMAD_SECRETS_DIR}/file.txt"
        env         = false
        change_mode = "restart"
        data = <<EOF
{{ with secret "nomad-jobs/data/redis-server" }}
REDIS_PASSWORD = "{{ .Data.data.password }}"
{{ end }}
EOF
      }

      config {
        image = "redis:7.0.7-alpine"
        args  = ["--requirepass", "${REDIS_PASSWORD}"]
        ports = ["db"]
      }
    }

    service {
      name     = "redis-server"
      port     = "db"
      provider = "nomad"
      tags     = ["redis", "v7.0.7", "server"]

      check {
        type     = "tcp"
        interval = "30s"
        timeout  = "5s"
      }
    }
  }
}
