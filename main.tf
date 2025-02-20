terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  #host = "unix:///var/run/docker.sock"  # For Mac/Linux
  host = "npipe:////./pipe/docker_engine"  # For Windows
}

# Create a network for WordPress and MySQL
resource "docker_network" "wp_network" {
  name = "wordpress_network"
}

# MySQL Database Container
resource "docker_image" "mysql" {
  name = "mysql:5.7"
}

resource "docker_container" "mysql" {
  name  = "mysql_db"
  image = docker_image.mysql.image_id
  restart = "always"

  env = [
    "MYSQL_ROOT_PASSWORD=rootpassword",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=wp_user",
    "MYSQL_PASSWORD=wp_password"
  ]

  networks_advanced {
    name = docker_network.wp_network.name
  }

  ports {
    internal = 3306
    external = 3306
  }
}

# WordPress Container
resource "docker_image" "wordpress" {
  name = "wordpress:latest"
}

resource "docker_container" "wordpress" {
  name  = "wordpress_site"
  image = docker_image.wordpress.image_id
  restart = "always"

  env = [
    "WORDPRESS_DB_HOST=mysql_db:3306",
    "WORDPRESS_DB_USER=wp_user",
    "WORDPRESS_DB_PASSWORD=wp_password",
    "WORDPRESS_DB_NAME=wordpress"
  ]

  networks_advanced {
    name = docker_network.wp_network.name
  }

  ports {
    internal = 80
    external = 8888
  }

  depends_on = [docker_container.mysql]
}