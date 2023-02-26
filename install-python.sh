#!/bin/bash


if [ ! -f ansible/.vault_pass ]
then
    echo "Please enter the vault password: "
    read vault_pass

    echo $vault_pass > ansible/.vault_pass
    chmod 0600 /ansible/.vault_pass
fi

# Download and move latest version of Python for Windows
if [ ! -f ansible/roles/windows/install-python311/files/python311.exe ]; then
  curl -o ansible/roles/windows/install-python311/files/python311.exe https://www.python.org/ftp/python/3.11.2/python-3.11.2-amd64.exe
fi

# Download and move latest version of Python for Linux
if [ ! -f ansible/roles/linux/install-python311/files/python311.tar.gz ]; then
  curl -o ansible/roles/linux/install-python311/files/python311.tar.gz https://www.python.org/ftp/python/3.11.2/Python-3.11.2.tar.xz
fi

ansible-galaxy collection install ansible.windows
ansible-galaxy collection install ansible.posix


echo ""
read -p "Enter target hosts to install Python 3.11 (comma-separated): " python_targets

# Check if targets exist in inventory file
if grep -qE "$python_targets" ansible/inventory.yml; then
  # Modify playbook file with new targets
  #sed -i "s/hosts: .*/hosts: \"$targets\"/" ansible/playbook-install-python311.yaml
  echo "Targets updated in playbook file"
  # Run the playbook
  cd ansible
  ansible-playbook -i inventory.yml --vault-password-file ./.vault_pass -e "python_targets=$python_targets" playbook-install-python311.yml
  cd ..
  echo ""
  echo ""
  echo "Action complete."
else
  echo "Invalid target hosts"
fi

echo ""