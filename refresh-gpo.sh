#!/bin/bash

if [ ! -f ansible/.vault_pass ]
then
    echo "Please enter the vault password: "
    read vault_pass

    echo $vault_pass > ansible/.vault_pass
    chmod 0600 /ansible/.vault_pass
fi

cd ansible
ansible-playbook -i inventory.yml --vault-password-file ./.vault_pass playbook-gpupdate.yml
echo ""
echo ""
echo "Action complete."
echo ""
cd ..