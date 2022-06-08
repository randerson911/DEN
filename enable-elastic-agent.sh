#!/bin/bash

sudo apt install unzip -y

wget https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-7.17.4-windows-x86_64.zip -O ansible/roles/windows/elastic-agent/files/elastic-agent-7.17.4-windows-x86_64.zip
unzip ansible/roles/windows/elastic-agent/files/elastic-agent-7.17.4-windows-x86_64.zip -d ansible/roles/windows/elastic-agent/files/

cd ansible
ansible-playbook -i inventory playbook-elastic-agent.yml

echo ""
echo ""
echo "Action complete."
echo ""
cd ..