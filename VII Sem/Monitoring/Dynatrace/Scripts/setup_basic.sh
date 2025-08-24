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
