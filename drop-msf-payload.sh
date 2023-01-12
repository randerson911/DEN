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
echo "Enter target(s): "
echo ""
echo "Targets must be separated by space. Valid targets include the following:"
echo "For groups of systems: subnet1 subnet2 subnet3"
echo "For specific system: user1 user2 user3 (up to user30)"
echo ""

echo "Enter red box IP: "
read redIP

echo "Enter red Executable Name: "
read redExec

sed -i "/red_ip:/c\red_ip: $redIP" ansible/group_vars/all/vars.yml
sed -i "/red_executable:/c\red_executable: $redExec" ansible/group_vars/all/vars.yml

echo "Enter target to drop payload to: "
read targs

sed -i "/- name: Drop/{n;s/.*/  hosts: $targs/}" ansible/playbook-msf-drop-payload.yml

cd ansible
ansible-playbook -i inventory playbook-msf-drop-payload.yml
echo ""
echo ""
echo "Action complete."
echo ""
cd ..