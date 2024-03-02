#!/bin/sh

sudo apt-get update -y
sudo apt-get install openjdk-17-jdk -y
sudo apt-get install maven -y
sudo apt update -y
sudo apt install software-properties-common -y
sudo apt-add-repository --yes --update ppa:ansible/ansible -y
sudo apt install ansible -y
