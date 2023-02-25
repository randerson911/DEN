#!/bin/bash


if [ ! -f ansible/.vault_pass ]
then
    echo "Please enter the vault password: "
    read vault_pass

    echo $vault_pass > ansible/.vault_pass
    chmod 0600 /ansible/.vault_pass
fi


# if [ ! -f umarker.txt ]
# then
#     echo ""
#     echo "Important: If you encounter errors in the ansible output, it will most likely be"
#     echo "credentials related. Please ensure you are providing the Windows credentials in"
#     echo "the following prompts. Delete the umarker.txt and input the correct values."
#     echo ""

#     echo "Enter Windows admin username: "
#     read denuser

#     echo "Enter Windows admin password: "
#     read denpass

#     sed -i "/den_user:/c\den_user: $denuser" ansible/group_vars/all/vars.yml
#     sed -i "/den_user_password:/c\den_user_password: $denpass" ansible/group_vars/all/vars.yml
#     echo "Complete." > umarker.txt
# fi

# Download and move latest version of Python for Windows
if [ ! -f ansible/roles/windows/install-python311/files/python311.exe ]; then
  curl -o ansible/roles/windows/install-python311/files/python311.exe https://www.python.org/ftp/python/3.11.2/python-3.11.2-amd64.exe
fi

# Download and move latest version of Python for Linux
if [ ! -f ansible/roles/linux/install-python311/files/python311.tar.gz]; then
  curl -o ansible/roles/linux/install-python311/files/python311.tar.gz https://www.python.org/ftp/python/3.11.2/Python-3.11.2.tar.xz
fi

echo ""
read -p "Enter target hosts (comma-separated): " targets

# Check if targets exist in inventory file
if grep -qE "$targets" ansible/inventory; then
  # Modify playbook file with new targets
  sed -i "s/hosts: .*/hosts: \"$targets\"/" ansible/playbook-install-python311.yaml
  echo "Targets updated in playbook file"
else
  echo "Invalid target hosts"
fi

# Run the playbook
cd ansible
ansible-playbook -i inventory playbook-install-python311.yml
echo ""
echo ""
echo "Action complete."
echo ""
cd ..


