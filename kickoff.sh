#! /bin/bash

## There is a large comment block here, as capabilities have moved to an encrypted ansible vault.

# if [ ! -f rmarker.txt ]
# then
#     echo ""
#     echo "Important: If you encounter errors in the ansible output, it will most likely be"
#     echo "credentials related. Please ensure you are providing the Kali Red credentials in"
#     echo "the following prompts. Delete the rmarker.txt and input the correct values."
#     echo ""

#     echo "Enter Kali username: "
#     read reduser

#     echo "Enter Kali password: "
#     read redpass

#     sed -i "/red_user:/c\red_user: $reduser" ansible/group_vars/all/vars.yml
#     sed -i "/red_user_password:/c\red_user_password: $redpass" ansible/group_vars/all/vars.yml
#     echo "Complete." > rmarker.txt
# fi

# if [ ! -f umarker.txt ]
# then
#     echo ""
#     echo "Important: If you encounter errors in the ansible output, it will most likely be"
#     echo "credentials related. Please ensure you are providing the Windows credentials in"
#     echo "the following prompts. Delete the umarker.txt and input the correct values."
#     echo ""

#     echo "Enter Windows admin username: "
#     read denuser

#     echo "Enter Windows admin password: "
#     read denpass

#     sed -i "/den_user:/c\den_user: $denuser" ansible/group_vars/all/vars.yml
#     sed -i "/den_user_password:/c\den_user_password: $denpass" ansible/group_vars/all/vars.yml
#     echo "Complete." > umarker.txt
# fi

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

lpass=""
if [ ! -f linuxcreds.txt ]
then
    echo "What is the linux password?"
    read lpass
    sed -i "/linux_user:/c\linux_user: cobra" ansible/group_vars/all/vars.yml
    sed -i "/linux_user_password:/c\linux_user_password: $lpass" ansible/group_vars/all/vars.yml
    echo "Complete." > linuxcreds.txt
else 
    lpass=$(grep "linux_user_password:" ./ansible/group_vars/all/vars.yml | awk '{print $2}')
fi


echo $lpass | sudo -S apt update
echo $lpass | sudo -S apt install unzip -y

echo ""
read -p "Enter target hosts to install Python on (comma-separated): " target_hosts
echo ""
sed -i "s/{{ python_target }}/${target_hosts}/" ansible/playbook-kickoff.yml

echo ""
echo "Downloading required files now!"
echo ""

if [ ! -f ansible/roles/windows/install-python311/files/python311.exe ]; then
    wget https://www.python.org/ftp/python/3.11.1/python-3.11.1-amd64.exe -O ansible/roles/windows/install-python311/files/python311.exe
fi

if [ ! -f ansible/roles/windows/elastic-agent/files/elastic-agent-7.17.4-windows-x86_64.zip ]; then
    wget https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-7.17.4-windows-x86_64.zip -O ansible/roles/windows/elastic-agent/files/elastic-agent-7.17.4-windows-x86_64.zip
    unzip ansible/roles/windows/elastic-agent/files/elastic-agent-7.17.4-windows-x86_64.zip -d ansible/roles/windows/elastic-agent/files/
fi

# Run the playbook
cd ansible
ansible-galaxy collection install davidban77.gns3
ansible-playbook -i inventory playbook-kickoff.yml
echo ""
echo ""
echo "Action complete."
echo ""
cd ..



