#!/bin/bash


if [ ! -f ./cobra.den ]
then
    echo "Please enter the vault password: "
    read -scobra.den

    echo cobra.den > ./cobra.den
    chmod 0600 ./cobra.den
fi

# # Download and move latest version of Python for Windows
# if [ ! -f ansible/roles/windows/vscode/files/vscode-latest.exe ]; then
#   curl -o ansible/roles/windows/vscode/files/vscode-latest.exe "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
# fi

read -p "Enter target host to install VS Code on: " target_host


ansible-playbook -e "target_host=$target_host" playbooks/production/playbook-install-vscode.yml

echo ""
