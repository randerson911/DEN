#!/bin/bash


if [ ! -f ./cobra.vault ]
then
    echo "Please enter the vault password: "
    read -s cobra.den

    echo cobra.den > ./cobra.vault
    chmod 0600 ./cobra.vault
fi


ansible-galaxy collection install davidban77.gns3
ansible-playbook -i inventory/production/inventory.yml --vault-password-file ./cobra.vault playbooks/production/playbook-tap-collector.yml
echo ""
echo ""
echo "Action complete."
echo ""
