#!/bin/bash

# Check installed Ansible version
pip install --upgrade --user $(pip freeze | awk '{split($0, a, "=="); print a[1]}')

