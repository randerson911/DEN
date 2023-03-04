#!/bin/bash


if [ ! -f ansible/.vault_pass ]
then
    echo "Please enter the vault password: "
    read -s vault_pass

    echo $vault_pass > ./ansible/.vault_pass
    chmod 0600 ./ansible/.vault_pass
fi


ansible-galaxy collection install davidban77.gns3
ansible-playbook -i inventory/production/inventory.yml.yml --vault-password-file ./.vault_passplaybooks/production/playbook-tap-collector.yml
echo ""
echo ""
echo "Action complete."
echo ""
