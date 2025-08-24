#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
echo "Starting system update..."
sudo apt update && echo "System update completed."

echo "Installing Git..."
sudo apt install git -y && echo "Git installation completed."

echo "Installing Unzip..."
sudo apt install unzip -y && echo "Unzip installation completed."

echo "Installing Maven..."
sudo apt install maven -y && echo "Maven installation completed."
mvn -version

echo "Installing OpenJDK 17..."
sudo apt install openjdk-17-jdk -y && echo "OpenJDK 17 installation completed."
java -version

echo "Installing Curl..."
sudo apt install curl -y && echo "Curl installation completed."

echo "Installing Ping..."
sudo apt install iputils-ping -y && echo "Ping installation completed."

echo "Installing Python 3..."
sudo apt-get install python3 -y && echo "Python 3 installation completed."

echo "Installing Pip for Python 3..."
sudo apt-get install python3-pip -y && echo "Python 3 Pip installation completed."

echo "Installing Docker..."
sudo apt install docker.io -y && echo "Docker installation completed."
sudo systemctl start docker && echo "Docker service started."
sudo systemctl enable docker && echo "Docker service enabled to start on boot."

echo "Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/v2.14.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && echo "Docker Compose downloaded."
sudo chmod +x /usr/local/bin/docker-compose && echo "Docker Compose permissions set."
docker-compose --version && echo "Docker Compose installation completed."

# Adding current user to Docker group, prompt for logout/re-login after script
echo "Adding current user to Docker group..."
sudo usermod -aG docker $USER && echo "User added to Docker group. Please log out and log back in for this change to take effect."

echo "Installing additional updates..."
sudo apt-get update -y && echo "Additional updates completed."

echo "All commands executed successfully."
echo "Please log out and log back in for Docker group changes to take effect."
