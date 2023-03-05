#!/bin/bash

if [ ! -f ./cobra.den ]
then
    echo "Please enter the vault password: "
    read -scobra.den

    echo cobra.den > ./cobra.den
    chmod 0600 ./cobra.den
fi


ansible-playbook -i inventory/production/inventory.yml --vault-password-file ./cobra.den playbooks/production/playbook-root-cert.yml
echo ""
echo ""
echo "Action complete."
echo ""
