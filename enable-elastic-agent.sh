#!/bin/bash

if [ ! -f ansible/.vault_pass ]
then
    echo "Please enter the vault password: "
    read vault_pass

    echo $vault_pass > ansible/.vault_pass
    chmod 0600 /ansible/.vault_pass
fi

# Read the value of my_secret from my_vault
cd ansible
lpass=$(ansible-vault view --vault-password-file ./.vault_pass cobra.vault | grep linux_user_password | cut -d ' ' -f 2)
cd ..

echo $lpass | sudo -S apt update
echo $lpass | sudo -S apt install unzip -y

if [ ! -f ansible/roles/windows/elastic-agent/files/elastic-agent-7.17.4-windows-x86_64.zip ]; then
    wget https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-7.17.4-windows-x86_64.zip -O ansible/roles/windows/elastic-agent/files/elastic-agent-7.17.4-windows-x86_64.zip
    unzip ansible/roles/windows/elastic-agent/files/elastic-agent-7.17.4-windows-x86_64.zip -d ansible/roles/windows/elastic-agent/files/
fi

cd ansible
ansible-playbook -i inventory.yml --vault-password-file ./.vault_pass -e "elastic_targets=datacenter,subnet1,subnet2,subnet3" playbook-elastic-agent.yml

echo ""
echo ""
echo "Action complete."
echo ""
cd ..