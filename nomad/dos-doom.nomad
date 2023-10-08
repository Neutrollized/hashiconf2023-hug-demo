job "dos-doom" {
  datacenters = ["gcp-east"]

  group "doom" {
    count = 1

    network {
      port "web" { to = 8000 }
    }

    task "doom" {
      driver = "docker"

      config {
        image = "neutrollized/dos-doom:latest"
        ports = ["web"]
      }
    }

    service {
      name     = "dos-doom"
      port     = "web"
      provider = "consul"
      tags     = ["doom", "emulator"]

      check {
        type     = "tcp"
        interval = "30s"
        timeout  = "5s"
      }
    }
  }
}
