job "container-factorial" {
  datacenters = ["dc1"]
  group "app" {
    network {
      port "http" {
        to = 80
      }
    }

    service {
      name = "container-factorial"
      port = "http"
      provider = "nomad"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.http.rule=Path(`/factorial`)",
      ]
    }

    task "app" {
      driver = "docker"
      config {
        image = "${artifact.image}:${artifact.tag}"
        ports = ["http"]

        // For local Nomad, you prob don't need this on a real deploy
        // network_mode = "host"
      }
      env {
        %{ for k, v in entrypoint.env~}
        ${ k } = "${v}"
        %{ endfor~}

        // For URL service
        // PORT = "3000"
      }
    }
  }
}