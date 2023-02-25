#!/bin/bash


if [ ! -f ansible/.vault_pass ]
then
    echo "Please enter the vault password: "
    read vault_pass

    echo $vault_pass > ansible/.vault_pass
    chmod 0600 /ansible/.vault_pass
fi


read -p "Enter target host to install VS Code on: " target_host

if grep -q "$target_host" ansible/inventory; then
    cd ansible
    ansible-playbook playbook-install-vscode.yml --extra-vars "target_host=$target_host"
else
    echo "Target host '$target_host' not found in inventory file."
    cd ..
    exit 1
fi

cd ..