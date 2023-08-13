project = "container-factorial"

app "container-factorial" {
  build {
    use "docker" {
    }
    registry {
      use "docker" {
        image = "samuelm333/container-factorial"
        tag   = "latest"
      }
    }
  }
  deploy {
    use "nomad-jobspec" {
      jobspec = templatefile("${path.app}/app.nomad.tpl")
    }
  }
  // release {
  //   use "nomad-jobspec-canary" {
  //     groups = [
  //       "app"
  //     ]
  //   }
  // }
}
