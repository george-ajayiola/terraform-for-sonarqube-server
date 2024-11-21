#!/bin/bash

# Update and install required packages
sudo apt-get update
sudo apt-get install -y ca-certificates curl

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository to Apt sources
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index and install Docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

#Increase vm.max_map_count Value: You can temporarily change this value using the following command
sudo sysctl -w vm.max_map_count=262144

#To ensure the change persists across reboots, you need to update the /etc/sysctl.conf file
sudo sh -c 'echo "vm.max_map_count=262144" >> /etc/sysctl.conf'

sudo sysctl -p

# Pull SonarQube image
docker pull sonarqube

# Start PostgreSQL container for SonarQube
docker run -d --name sonarqube-db -e POSTGRES_USER=<username> -e POSTGRES_PASSWORD=<password> -e POSTGRES_DB=sonarqube postgres:alpine

# Start SonarQube container, linking it to the PostgreSQL database
docker run -d --name sonarqube -p 9000:9000 --link sonarqube-db:db -e SONAR_JDBC_URL=jdbc:postgresql://db:5432/sonarqube -e SONAR_JDBC_USERNAME=<username> -e SONAR_JDBC_PASSWORD=<password> sonarqube


