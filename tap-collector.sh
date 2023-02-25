#!/bin/bash
echo ""
echo "Important: If you encounter errors in the ansible output, it will most likely be"
echo "credentials related. Please ensure you are providing the Linux credentials in"
echo "the following prompts."
echo ""

if [ ! -f linuxcreds.txt ]
then
    echo ""
    echo "Important: If you encounter errors in the ansible output, it will most likely be"
    echo "credentials related. Please ensure you are providing the linux credentials in"
    echo "the following prompts. Delete the linuxcreds.txt and input the correct values."
    echo ""

    echo "Enter linux username: "
    read linuxuser

    echo "Enter linux password: "
    read linuxpass

    sed -i "/linux_user:/c\linux_user: $linuxuser" ansible/group_vars/all/vars.yml
    sed -i "/linux_user_password:/c\linux_user_password: $linuxpass" ansible/group_vars/all/vars.yml
    echo "Complete." > linuxcreds.txt
fi

cd ansible
ansible-galaxy collection install davidban77.gns3
ansible-playbook -i inventory --vault-password-file ./.vault_pass playbook-tap-collector.yml
echo ""
echo ""
echo "Action complete."
echo ""
cd ..