#!/bin/bash

echo ""
echo "Please provide sudo password to install apt dependency on the ansible server. This is the linux"
echo "password in the VTA."
echo ""
sudo apt install unzip -y

wget https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-7.17.4-windows-x86_64.zip -O ansible/roles/windows/elastic-agent/files/elastic-agent-7.17.4-windows-x86_64.zip
unzip ansible/roles/windows/elastic-agent/files/elastic-agent-7.17.4-windows-x86_64.zip -d ansible/roles/windows/elastic-agent/files/

if [ ! -f umarker.txt ]
then
    echo ""
    echo "Important: If you encounter errors in the ansible output, it will most likely be"
    echo "credentials related. Please ensure you are providing the Windows credentials in"
    echo "the following prompts. Delete the umarker.txt and input the correct values."
    echo ""

    echo "Enter Windows admin username: "
    read denuser

    echo "Enter Windows admin password: "
    read denpass

    sed -i "/den_user:/c\den_user: $denuser" ansible/group_vars/all/vars.yml
    sed -i "/den_user_password:/c\den_user_password: $denpass" ansible/group_vars/all/vars.yml
    echo "Complete." > umarker.txt
fi

cd ansible
ansible-playbook -i inventory playbook-elastic-agent.yml

echo ""
echo ""
echo "Action complete."
echo ""
cd ..