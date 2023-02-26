#!/bin/bash

# Check installed Ansible version
installed_version=$(ansible --version | grep "^ansible" | awk '{print $2}')

# Check latest Ansible version
latest_version=$(curl -s https://api.github.com/repos/ansible/ansible/releases/latest | grep tag_name | cut -d '"' -f 4)

# Compare versions and upgrade if necessary
if [[ "$installed_version" != "$latest_version" ]]; then
    echo "Upgrading Ansible from $installed_version to $latest_version"
    pip install ansible=="$latest_version"
else
    echo "Ansible is already up to date"
fi
