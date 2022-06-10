#!/bin/bash
echo ""
echo "Important: If you encounter errors in the ansible output, it will most likely be"
echo "credentials related. Please ensure you are providing the Linux credentials in"
echo "the following prompts."
echo ""

cd ansible
ansible-galaxy collection install davidban77.gns3
ansible-playbook -i inventory playbook-tap-collector.yml -K
echo ""
echo ""
echo "Action complete."
echo ""
cd ..