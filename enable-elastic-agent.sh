#!/bin/bash

echo ""
echo "Please provide sudo password to install apt dependency on the ansible server. This is the linux"
echo "password in the VTA."
echo ""
if [ ! -f linuxcreds.txt ]
then
    read -p "What is the linux password? " lpass
    sed -i "/linux_user:/c\linux_user: cobra" ansible/group_vars/all/vars.yml
    sed -i "/linux_user_password:/c\linux_user_password: $lpass" ansible/group_vars/all/vars.yml
    echo $lpass | sudo -S apt update
    echo $lpass | sudo -S apt install unzip -y
    echo "Complete." > linuxcreds.txt
else 
    lpass=$(grep "linux_user_password:" ./ansible/group_vars/all/vars.yml | awk '{print $2}')
    echo $lpass | sudo -S apt update
    echo $lpass | sudo -S apt install unzip -y
fi

if [ ! -f ansible/roles/windows/elastic-agent/files/elastic-agent-7.17.4-windows-x86_64.zip ]; then
    wget https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-7.17.4-windows-x86_64.zip -O ansible/roles/windows/elastic-agent/files/elastic-agent-7.17.4-windows-x86_64.zip
    unzip ansible/roles/windows/elastic-agent/files/elastic-agent-7.17.4-windows-x86_64.zip -d ansible/roles/windows/elastic-agent/files/
fi

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