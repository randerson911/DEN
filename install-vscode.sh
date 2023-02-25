#!/bin/bash


if [ ! -f ansible/.vault_pass ]
then
    echo "Please enter the vault password: "
    read vault_pass

    echo $vault_pass > ansible/.vault_pass
    chmod 0600 /ansible/.vault_pass
fi


read -p "Enter target host to install VS Code on: " target_host


# Check if targets exist in inventory file
if grep -qE "$target_host" ansible/inventory; then
    # Modify playbook file with new targets
    sed -i "s/hosts: .*/hosts: \"$target_host\"/" ansible/playbook-install-vscode.yaml
    echo "Targets updated in playbook file"
    cd ansible
    ansible-playbook -i inventory --vault-password-file ./.vault_pass playbook-install-vscode.yml
    cd ..
else
    echo "Target host '$target_host' not found in inventory file."
    cd ..
    exit 1
fi
