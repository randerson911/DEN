#!/bin/bash
echo ""
echo "Important: If you encounter errors in the ansible output, it will most likely be"
echo "credentials related. Please ensure you are providing the Windows credentials in"
echo "the following prompts."
echo ""

echo "Enter Windows admin username: "
read denuser

echo "Enter Windows admin password: "
read denpass

sed -i "s/see_vta_for_user/$denuser/g" ansible/group_vars/all/vars.yml
sed -i "s/see_vta_for_pass/$denpass/g" ansible/group_vars/all/vars.yml

cd ansible
ansible-playbook -i inventory playbook-get-random-users.yml
echo ""
echo ""
echo "Action complete."
echo ""
cd ..