job "http-echo-gui" {
  datacenters = ["gcp-ca-east"]

  group "echo" {
  
    network {
        port "heartbeat" {
            to = 8080
            }
    }

    count = 1
    task "server" {
      driver = "docker"  
      config {
        image = "hashicorp/http-echo:latest"
        ports = ["heartbeat"]
        args  = [
          "-listen", ":${NOMAD_PORT_heartbeat}",
          "-text", "${attr.os.name}: server running on ${NOMAD_IP_heartbeat} with port ${NOMAD_PORT_heartbeat}",
        ]
      }
      service {
        name = "http-echo"
        port = "heartbeat"
        
        tags = [
          "heartbeat",
          "urlprefix-/",
        ]

        check {
          type     = "http"
          path     = "/health"
          interval = "2s"
          timeout  = "2s"
        }
      }
    }
  }
}
