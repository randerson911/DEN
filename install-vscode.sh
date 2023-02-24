#!/bin/bash

read -p "Enter target host to install VS Code on: " target_host

if grep -q "$target_host" ansible/inventory; then
    cd ansible
    ansible-playbook playbook-install-vscode.yaml --extra-vars "target_host=$target_host"
else
    echo "Target host '$target_host' not found in inventory file."
    exit 1
fi

cd ..