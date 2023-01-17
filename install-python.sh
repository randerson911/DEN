#!/bin/bash

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

echo ""
read -p "Enter target hosts (comma-separated): " target_hosts
echo ""

if [ ! -e ansible/roles/windows/install-python311/files/python311.exe]; then
    wget https://www.python.org/ftp/python/3.11.1/python-3.11.1-amd64.exe -O ansible/roles/windows/install-python311/files/python311.exe
fi

# Replace the hosts field in the playbook with the provided input
sed -i "s/hosts:.*/hosts: ${target_hosts}/" ansible/playbook-install-python311.yml

# Run the playbook
cd ansible
ansible-playbook -i inventory playbook-install-python311.yml
cd ..
echo ""
echo ""
echo "Action complete."
echo ""
cd ..


