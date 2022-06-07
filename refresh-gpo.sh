#!/bin/bash

cd ansible
ansible-playbook -i inventory playbook-gpupdate.yml
echo ""
echo ""
echo "Action complete."
echo ""
cd ..