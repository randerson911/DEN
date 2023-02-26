#!/bin/bash


if [ ! -f ansible/.vault_pass ]
then
    echo "Please enter the vault password: "
    read vault_pass

    echo $vault_pass > ansible/.vault_pass
    chmod 0600 /ansible/.vault_pass
fi

ansible-galaxy collection install ansible.windows
ansible-galaxy collection install ansible.posix

read -p "Enter target host to install VS Code on: " target_host


# Check if targets exist in inventory file
if grep -qE "$target_host" ansible/inventory; then
    # Modify playbook file with new targets
    cd ansible
    ansible-playbook -i inventory --vault-password-file ./.vault_pass -e "target_hosts=$target_host" playbook-install-vscode.yml
    cd ..
else
    echo "Target host '$target_host' not found in inventory file."
    exit 1
fi
