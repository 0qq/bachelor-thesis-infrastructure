#!/usr/bin/env bash
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
cat <<EOF | tee /etc/apt/sources.list.d/jenkins.list
  deb https://pkg.jenkins.io/debian-stable binary/
  EOF
apt-get update
apt-get -y upgrade
apt install -y openjdk-11-jre-headless jenkins
apt install -y jenkins
