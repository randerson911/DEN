#!/bin/bash


if [ ! -f ./cobra.vault ]
then
    echo "Please enter the vault password: "
    read -s cobra.den

    echo cobra.den > ./cobra.vault
    chmod 0600 ./cobra.vault
fi

echo ""
echo "Enter target(s): "
echo ""
echo "Targets must be separated by space. Valid targets include the following:"
echo "For groups of systems: subnet1 subnet2 subnet3"
echo "For specific system: user1 user2 user3 (up to user30)"
echo ""

echo "Enter target to drop/run payload to: "
read targs

sed -i "/- name: Run/{n;s/.*/  hosts: $targs/}" ansible/playbook-run-payload.yml


#read -p "[true/false] Is the Payload an Executable? " isexecutable
echo "Enter the payload to be sent to the devices. Leave blank to re-run the previous payload"
read payload
[[ -z "$payload" ]] && echo "Continuing On" || echo $payload > ansible/roles/red/run-payload/files/payload-template.j2


ansible-playbook -i inventory/production/inventory.yml --vault-password-file ./cobra.vault playbooks/production/playbook-run-payload.yml
echo ""
echo ""
echo "Action complete."
echo ""

