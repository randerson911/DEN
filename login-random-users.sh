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
cd ..
cat users.txt
echo ""
echo "Modify inventory file and integrate selected users."

lines=$(cat users.txt)
for line in $lines
counter=0
head="user"
tail=":var"
varname="username="
do
    $counter=$counter+1
    echo [$head$counter$var] >> ansible/inventory
    echo $varname$line | xargs >> ansible/inventory
    echo "" >> ansible/inventory
done

echo ""
echo ""
echo "Action complete."
echo ""
