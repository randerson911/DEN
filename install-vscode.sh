#!/bin/bash


if [ ! -f ./.vault_pass ]
then
    echo "Please enter the vault password: "
    read -s vault_pass

    echo $vault_pass > ./.vault_pass
    chmod 0600 ./.vault_pass
fi

# # Download and move latest version of Python for Windows
# if [ ! -f ansible/roles/windows/vscode/files/vscode-latest.exe ]; then
#   curl -o ansible/roles/windows/vscode/files/vscode-latest.exe "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
# fi

read -p "Enter target host to install VS Code on: " target_host


ansible-playbook -i inventory/production/inventory.yml.yml --vault-password-file ./.vault_pass -e "target_host=$target_host" playbooks/production/playbook-install-vscode.yml

echo ""
