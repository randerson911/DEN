#!/bin/bash

if [ ! -f ./cobra.den ]
then
    echo "Please enter the vault password: "
    read -scobra.den

    echo cobra.den > ./cobra.den
    chmod 0600 ./cobra.den
fi

echo ""
echo "Enter target(s): "
echo ""
echo "Targets must be separated by space. Valid targets include the following:"
echo "For groups of systems: subnet1 subnet2 subnet3"
echo "For specific system: user1 user2 user3 (up to user30)"
echo ""

echo "Enter red box Inventory Name: "
read redHost

sed -i "/- name: Install/{n;s/.*/  hosts: $redHost/}" ansible/playbook-covenant.yml

ansible-playbook -i inventory/production/inventory.yml --vault-password-file ./cobra.den playbooks/production/playbook-covenant.yml
echo ""
echo ""
echo "Action complete."
echo ""
