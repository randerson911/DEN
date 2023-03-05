#!/bin/bash


if [ ! -f ./cobra.den ]
then
    echo "Please enter the vault password: "
    read -s cobra.den

    echo cobra.den > ./cobra.den
    chmod 0600 ./cobra.den
fi


ansible-galaxy collection install davidban77.gns3
ansible-playbook -i inventory/production/inventory.yml --vault-password-file ./cobra.den playbooks/production/playbook-tap-collector.yml
echo ""
echo ""
echo "Action complete."
echo ""
