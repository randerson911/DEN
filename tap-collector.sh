#!/bin/bash


if [ ! -f ansible/.vault_pass ]
then
    echo "Please enter the vault password: "
    read -s vault_pass

    echo $vault_pass > ./.vault_pass
    chmod 0600 ./.vault_pass
fi


ansible-galaxy collection install davidban77.gns3
ansible-playbook -i inventory/production/inventory.yml.yml --vault-password-file ./.vault_pass playbooks/production/playbook-tap-collector.yml
echo ""
echo ""
echo "Action complete."
echo ""
