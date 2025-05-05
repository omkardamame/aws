#!/bin/bash

# Update package lists
apt update

# Install essential packages
apt install htop dnsutils fontconfig -y

# Install JDK 21 using the .deb file (preferred method)
mkdir /tmp/jenkins && cd /tmp/jenkins

# Download and install Java
wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.deb
dpkg -i jdk-21_linux-x64_bin.deb

# Install OpenJDK 21 via tar file (discarded method)
#wget https://download.java.net/java/GA/jdk21.0.2/f2283984656d49d69e91c558476027ac/13/GPL/openjdk-21.0.2_linux-x64_bin.tar.gz
#tar xvf openjdk-21.0.2_linux-x64_bin.tar.gz
#mv jdk-21.0.2/ /usr/local/jdk-21

# Set JAVA_HOME environment variable
tee -a /etc/profile.d/jdk21.sh<<EOF
export JAVA_HOME=/usr/local/jdk-21
export PATH=$PATH:$JAVA_HOME/bin
EOF

# Jenkins setup by adding keyring, repository
wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Install Jenkins
apt update
apt install jenkins -y

# Enable and start Jenkins service
systemctl enable --now jenkins

# Cleanup temporary files
cd ~
rm -rf /tmp/jenkins
echo "Jenkins installation completed." > /home/admin/Jenkins_installation_completed
