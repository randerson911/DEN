#!/bin/bash


if [ ! -f ansible/.vault_pass ]
then
    echo "Please enter the vault password: "
    read -s vault_pass

    echo $vault_pass > ./ansible/.vault_pass
    chmod 0600 ./ansible/.vault_pass
fi

ansible-galaxy collection install ansible.windows
ansible-galaxy collection install ansible.posix

# Download and move latest version of Python for Windows
if [ ! -f ansible/roles/windows/vscode/files/vscode-latest.exe ]; then
  curl -o ansible/roles/windows/vscode/files/vscode-latest.exe https://www.python.org/ftp/python/3.11.2/python-3.11.2-amd64.exe
fi

read -p "Enter target host to install VS Code on: " target_host

cd ansible
ansible-playbook -i inventory.yml --vault-password-file ./.vault_pass -e "target_host=$target_host" playbook-install-vscode.yml
cd ..
echo ""
