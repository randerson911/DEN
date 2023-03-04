#! /bin/bash

if [ ! -f ./.vault_pass ]
then
    echo "Please enter the vault password: "
    read -s vault_pass

    echo $vault_pass > ./.vault_pass
    chmod 0600 ./.vault_pass
fi


# Read the value of my_secret from my_vault

lpass=$(ansible-vault view --vault-password-file ./.vault_pass cobra.vault.yml | grep linux_user_password | cut -d ' ' -f 2)


# echo $lpass | sudo -S apt update
# echo $lpass | sudo -S apt install unzip jq -y

if [ -f users.txt ]
then
    echo "It looks like you already have a list of users."
    echo "Do you wish to generate a new one?"
    echo ""
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) rm -f users.txt; break;;
            No ) break;;
        esac
    done
fi

if [ ! -f users.txt ]
then
    
    ansible-playbook -i inventory/production/inventory.yml.yml --vault-password-file ./.vault_pass playbooks/production/playbook-get-random-users.yml
    
    sed -i 's/[^[:print:]]//g' users.txt
    sed -i '/^$/d' users.txt
    sed -i '1d' users.txt
    sed -r -i 's/\s+//g' users.txt
    cat users.txt
fi

if [ ! -f lmarker.txt ]; then
  pip3 install pyyaml
  
  python3 ./login-random-users.py ./ansible/inventory.yml users.txt

  echo "Inventory has been updated to include uname: username vars now."
  echo "Complete!" > lmarker.txt

fi

if [ ! -f elmarker.txt ]
then
    echo "Enter elastic username: "
    read elasticuser

    echo "Enter elastic password: "
    read elasticpass

    if [[ $(curl -k -u $elasticuser:$elasticpass --write-out '%{http_code}' --silent --output /dev/nul -XGET https://172.17.60.40:5601/status -I) != 200 ]]; then
        echo "Invalid Elasticsearch username or password. Please check and retry."
        exit
    fi

    sed -i "/el_user:/c\el_user: $elasticuser" ansible/group_vars/all/vars.yml
    sed -i "/el_user_password:/c\el_user_password: $elasticpass" ansible/group_vars/all/vars.yml
    sed -i "s/elastic_user_in_vta/$elasticuser/g" ansible/roles/windows/winlogbeat/files/winlogbeat.yml
    sed -i "s/elastic_password_in_vta/$elasticpass/g" ansible/roles/windows/winlogbeat/files/winlogbeat.yml
    echo $elasticuser:$elasticpass > elmarker.txt
fi

# Print the value of my_secret
#echo "The linux password is: $lpass"

# echo ""
# echo "Downloading required files now!"
# echo ""

# if [ ! -f ansible/roles/windows/elastic-agent/files/elastic-agent-7.17.4-windows-x86_64.zip ] ; then
#     wget https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-7.17.4-windows-x86_64.zip -O ansible/roles/windows/elastic-agent/files/elastic-agent-7.17.4-windows-x86_64.zip
#     unzip ansible/roles/windows/elastic-agent/files/elastic-agent-7.17.4-windows-x86_64.zip -d ansible/roles/windows/elastic-agent/files/
# fi

# # Download and move latest version of Python for Windows
# if [ ! -f ansible/roles/windows/install-python311/files/python311.exe ] ; then
#     curl -o ansible/roles/windows/install-python311/files/python311.exe https://www.python.org/ftp/python/3.11.2/python-3.11.2-amd64.exe
# fi

# # Download and move latest version of Python for Linux
# if [ ! -f ansible/roles/linux/install-python311/files/python311.tar.gz ] ; then
#     curl -o ansible/roles/linux/install-python311/files/python311.tar.gz https://www.python.org/ftp/python/3.11.2/Python-3.11.2.tar.xz
# fi

echo ""
read -p "Enter target hosts to install Python 3.11 (comma-separated): " targets
echo "Targets updated in playbook file"

# Run the playbook

ansible-galaxy collection install davidban77.gns3
ansible-galaxy collection install ansible.windows
ansible-galaxy collection install ansible.posix

ansible-playbook -i inventory/production/inventory.yml.yml --vault-password-file ./.vault_pass -e "target_host=$targets" -e "elastic_targets=datacenter,subnet1,subnet2,subnet3" playbooks/production/playbook-kickoff.yml
echo ""
echo ""
echo "Action complete."
echo ""




