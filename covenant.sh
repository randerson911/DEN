#!/bin/bash

if [ ! -f rmarker.txt ]
then
    echo ""
    echo "Important: If you encounter errors in the ansible output, it will most likely be"
    echo "credentials related. Please ensure you are providing the Kali Red credentials in"
    echo "the following prompts. Delete the rmarker.txt and input the correct values."
    echo ""

    echo "Enter Kali username: "
    read reduser

    echo "Enter Kali password: "
    read redpass

    sed -i "/red_user:/c\red_user: $reduser" ansible/group_vars/all/vars.yml
    sed -i "/red_user_password:/c\red_user_password: $redpass" ansible/group_vars/all/vars.yml
    echo "Complete." > rmarker.txt
fi

echo ""
echo "Enter target(s): "
echo ""
echo "Targets must be separated by space. Valid targets include the following:"
echo "For groups of systems: subnet1 subnet2 subnet3"
echo "For specific system: user1 user2 user3 (up to user30)"
echo ""

echo "Enter red box Inventory Name: "
read redHost

sed -i "/- name: Install/{n;s/.*/  hosts: $redHost/}" ansible/playbook-covenant.yml
cd ansible
ansible-playbook -i inventory playbook-covenant.yml
echo ""
echo ""
echo "Action complete."
echo ""
cd ..