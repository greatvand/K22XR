#!/bin/bash

# Update the system's package index
echo "Updating the system's package index..."
sudo apt-get update -y

# Step 1: Add the Jenkins repository key to your system
echo "Adding the Jenkins repository key..."
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

# Step 2: Add Jenkins repository to your sources list with signed-by option
echo "Adding Jenkins repository to the sources list..."
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null

# Step 3: Update the package index again to recognize the new Jenkins repository
echo "Updating package index with new Jenkins repository..."
sudo apt-get update -y

# Step 4: Install Jenkins and its dependencies
echo "Installing Jenkins..."
sudo apt-get install jenkins -y

# Step 5: Start Jenkins service
echo "Starting Jenkins service..."
sudo systemctl start jenkins

# Step 6: Enable Jenkins to start on boot
echo "Enabling Jenkins to start on boot..."
sudo systemctl enable jenkins

# Step 7: Check Jenkins status to verify it is running
echo "Checking Jenkins service status..."
sudo systemctl status jenkins

# Final message
echo "Jenkins installation and setup completed successfully!"
echo "You can access Jenkins by going to http://<your-server-ip>:8080"
echo "To get the Jenkins admin password, run: sudo cat /var/lib/jenkins/secrets/initialAdminPassword"

sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
