job "redis-client" {
  datacenters = ["gcp-ca-east"]

  group "redis" {
    count = 1

    task "client" {
      driver = "docker"

      template {
        destination = "${NOMAD_SECRETS_DIR}/redis_password.vars"
        env         = true
        change_mode = "restart"
        data        = <<EOF
{{ with nomadVar "nomad/jobs/redis-client" }}
REDISCLI_AUTH = {{ .rediscli_password }}
{{ end }}
EOF
      }

      template {
        destination = "${NOMAD_TASK_DIR}/service.vars"
        env         = true
        change_mode = "restart"
        data        = <<EOF
{{ range nomadService "redis-server" }}
REDIS_SERVER_HOST={{ .Address }}
REDIS_SERVER_PORT={{ .Port }}
{{ end }}
EOF
      }

      config {
        image = "redis:7.0.7-alpine"
      }
    }

  }
}
