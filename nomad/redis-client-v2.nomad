job "redis-client-v2" {
  datacenters = ["gcp-ca-east"]

  group "redis" {
    count = 1

    task "client" {
      driver = "docker"

      vault {
        policies = ["nomad_jobs_ro"]
        env      = false
      }

      template {
        destination = "secrets/file.env"
        env         = true
        change_mode = "restart"
        data = <<EOF
{{ with secret "nomad-jobs/data/redis-server" }}
REDISCLI_AUTH = "{{ .Data.data.password }}"
{{ end }}
EOF

      }

      template {
        destination = "local/service.vars"
        env         = true
        change_mode = "restart"
        data        = <<EOF
{{ range service "redis-server" }}
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
