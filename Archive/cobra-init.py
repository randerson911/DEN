#! /usr/bin/python3

import subprocess

# List of Ansible modules to install
ansible_modules = [
    "ansible",
    "ansible-lint",
    "ansible-base",
    "ansible-runner",
    "ansible-runner-http",
    "ansible-runner-service",
    "ansible-runner-workflow",
    "ansible-tower-cli",
    "molecule",
    "testinfra"
]

# Install each module using pip
for module in ansible_modules:
    subprocess.call(["pip", "install", module])
