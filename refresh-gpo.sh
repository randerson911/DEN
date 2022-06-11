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

    sed -i "s/see_vta_for_user/$denuser/g" ansible/group_vars/all/vars.yml
    sed -i "s/see_vta_for_pass/$denpass/g" ansible/group_vars/all/vars.yml
    echo "Complete." > umarker.txt
fi

cd ansible
ansible-playbook -i inventory playbook-gpupdate.yml
echo ""
echo ""
echo "Action complete."
echo ""
cd ..