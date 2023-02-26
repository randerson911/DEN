#! /bin/bash

if [ ! -f ansible/.vault_pass ]
then
    echo "Please enter the vault password: "
    read -s vault_pass

    echo $vault_pass > ./ansible/.vault_pass
    chmod 0600 ./ansible/.vault_pass
fi

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
    cd ansible
    ansible-playbook -i inventory.yml --vault-password-file ./.vault_pass playbook-get-random-users.yml
    cd ..
    sed -i 's/[^[:print:]]//g' users.txt
    sed -i '/^$/d' users.txt
    sed -i '1d' users.txt
    sed -r -i 's/\s+//g' users.txt
    cat users.txt
fi

if [ ! -f lmarker.txt ]
then

    if grep -q "user1:vars" ansible/inventory
    then
        lnr=$(sed -n '/##marker/=' ansible/inventory)
        sed -i "1, $lnr ! d" ansible/inventory
    fi

    echo ""
    echo "Modify inventory file and integrate selected users."

    c=0
    var1="user"
    var2=":vars"
    varname="uname="

    cat users.txt | while read line
    do
        let c=c+1
        echo "" >> ansible/inventory
        echo [$var1$c$var2] >> ansible/inventory
        echo $varname$line >> ansible/inventory
    done
    echo "Complete." > lmarker.txt
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

# Prompt for the vault password
echo "Enter the cobra vault password: "
read -s vault_pass

# Read the value of my_secret from my_vault
cd ansible
lpass=$(ansible-vault view --vault-password-file ./.vault_pass cobra.vault | grep linux_user_password | cut -d ' ' -f 2)
cd ..

echo $lpass | sudo -S apt update
echo $lpass | sudo -S apt install unzip -y

# Print the value of my_secret
#echo "The linux password is: $lpass"

echo ""
echo "Downloading required files now!"
echo ""

if [ ! -f ansible/roles/windows/elastic-agent/files/elastic-agent-7.17.4-windows-x86_64.zip ] ; then
    wget https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-7.17.4-windows-x86_64.zip -O ansible/roles/windows/elastic-agent/files/elastic-agent-7.17.4-windows-x86_64.zip
    unzip ansible/roles/windows/elastic-agent/files/elastic-agent-7.17.4-windows-x86_64.zip -d ansible/roles/windows/elastic-agent/files/
fi

# Download and move latest version of Python for Windows
if [ ! -f ansible/roles/windows/install-python311/files/python311.exe ] ; then
    curl -o ansible/roles/windows/install-python311/files/python311.exe https://www.python.org/ftp/python/3.11.2/python-3.11.2-amd64.exe
fi

# Download and move latest version of Python for Linux
if [ ! -f ansible/roles/linux/install-python311/files/python311.tar.gz ] ; then
    curl -o ansible/roles/linux/install-python311/files/python311.tar.gz https://www.python.org/ftp/python/3.11.2/Python-3.11.2.tar.xz
fi

echo ""
read -p "Enter target hosts to install Python 3.11 (comma-separated): " targets

# Check if targets exist in inventory file
if grep -qE "$targets" ansible/inventory ; then
    # Modify playbook file with new targets
    echo "Targets updated in playbook file"
else
    echo "Invalid target hosts"
fi

# Run the playbook
cd ansible
ansible-galaxy collection install davidban77.gns3
ansible-galaxy collection install ansible.windows
ansible-galaxy collection install ansible.posix

ansible-playbook -i inventory.yml --vault-password-file ./.vault_pass -e "target_host=$targets" -e "elastic_targets=datacenter,subnet1,subnet2,subnet3" playbook-kickoff.yml
echo ""
echo ""
echo "Action complete."
echo ""
cd ..



