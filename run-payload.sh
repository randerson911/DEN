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
echo "Enter target(s): "
echo ""
echo "Targets must be separated by space. Valid targets include the following:"
echo "For groups of systems: subnet1 subnet2 subnet3"
echo "For specific system: user1 user2 user3 (up to user30)"
echo ""

echo "Enter target to drop payload to: "
read targs

sed -i "/- name: Run/{n;s/.*/  hosts: $targs/}" ansible/playbook-run-payload.yml

echo "Enter the payload to be sent to the devices"
read payload

echo $payload -n > ansible/roles/misc/run-payload/files/payload-template.j2

cd ansible
ansible-playbook -i inventory playbook-run-payload.yml
echo ""
echo ""
echo "Action complete."
echo ""
cd ..