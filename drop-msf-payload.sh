#!/bin/bash

if [ ! -f rmarker.txt ]
then
    echo ""
    echo "Important: If you encounter errors in the ansible output, it will most likely be"
    echo "credentials related. Please ensure you are providing the Kali Red credentials in"
    echo "the following prompts. Delete the umarker.txt and input the correct values."
    echo ""

    echo "Enter Kali username: "
    read reduser

    echo "Enter Kali password: "
    read redpass

    sed -i "s/see_vta_for_red_user/$reduser/g" ansible/group_vars/all/vars.yml
    sed -i "s/see_vta_for_red_pass/$redpass/g" ansible/group_vars/all/vars.yml
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

    sed -i "s/see_vta_for_user/$denuser/g" ansible/group_vars/all/vars.yml
    sed -i "s/see_vta_for_pass/$denpass/g" ansible/group_vars/all/vars.yml
    echo "Complete." > umarker.txt
fi

echo ""
echo "Enter target(s): "
echo ""
echo "Targets must be separated by space. Valid targets include the following:"
echo "For groups of systems: datacenter subnet1 subnet2 subnet3"
echo "For specific system: dc1 dc2 user1 .. user30"
echo ""

echo "Enter target to drop payload to: "
read targs

sed -i "/msf-targets/c\msf-targets: $targs/" ansible/group_vars/all/vars.yml

cd ansible
ansible-playbook -i inventory playbook-msf-drop-payload.yml
echo ""
echo ""
echo "Action complete."
echo ""
cd ..