#!/bin/bash

if [ ! -f ./cobra.vault ]
then
    echo "Please enter the vault password: "
    read -s cobra.den

    echo cobra.den > ./cobra.vault
    chmod 0600 ./cobra.vault
fi

# Read the value of my_secret from my_vault

lpass=$(ansible-vault view --vault-password-file ./cobra.vault cobra.vault.yml | grep linux_user_password | cut -d ' ' -f 2)


# echo $lpass | sudo -S apt update
# echo $lpass | sudo -S apt install unzip -y

# if [ ! -f ansible/roles/windows/elastic-agent/files/elastic-agent-7.17.4-windows-x86_64.zip ]; then
#     wget https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-7.17.4-windows-x86_64.zip -O ansible/roles/windows/elastic-agent/files/elastic-agent-7.17.4-windows-x86_64.zip
#     unzip ansible/roles/windows/elastic-agent/files/elastic-agent-7.17.4-windows-x86_64.zip -d ansible/roles/windows/elastic-agent/files/
# fi

# if [ ! -f ansible/roles/linux/elastic-agent/files/elastic-agent-7.17.4-linux-x86_64.tar.gz ]; then
#     wget https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-7.17.4-linux-x86_64.tar.gz -O ansible/roles/linux/elastic-agent/files/elastic-agent-7.17.4-linux-x86_64.tar.gz
#     tar -xzvf ansible/roles/linux/elastic-agent/files/elastic-agent-7.17.4-linux-x86_64.tar.gz -C ansible/roles/linux/elastic-agent/files/
# fi



ansible-playbook -i inventory/production/inventory.yml --vault-password-file ./cobra.vault -e "elastic_targets=datacenter,subnet1,subnet2,subnet3" playbooks/production/playbook-elastic-agent.yml

echo ""
echo ""
echo "Action complete."
echo ""
