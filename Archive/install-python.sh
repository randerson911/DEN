#!/bin/bash


if [ ! -f ./cobra.vault ]
then
    echo "Please enter the vault password: "
    read -s cobra.den

    echo cobra.den > ./cobra.vault
    chmod 0600 ./cobra.vault
fi

# # Download and move latest version of Python for Windows
# if [ ! -f ansible/roles/windows/install-python311/files/python311.exe ]; then
#   curl -o ansible/roles/windows/install-python311/files/python311.exe https://www.python.org/ftp/python/3.11.2/python-3.11.2-amd64.exe
# fi

# # Download and move latest version of Python for Linux
# if [ ! -f ansible/roles/linux/install-python311/files/python311.tar.gz ]; then
#   curl -o ansible/roles/linux/install-python311/files/python311.tar.gz https://www.python.org/ftp/python/3.11.2/Python-3.11.2.tar.xz
# fi

echo ""
read -p "Enter target hosts to install Python 3.11 (comma-separated): " python_targets

ansible-playbook -i inventory/production/inventory.yml --vault-password-file ./cobra.vault -e "python_targets=$python_targets" playbooks/production/playbook-install-python311.yml

echo ""
echo ""
echo "Action complete."
echo ""