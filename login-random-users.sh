#!/bin/bash

if [ ! -f users.txt ]
then
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
fi

if [ ! -f userlist.txt ]
then
    echo ""
    echo "Modify inventory file and integrate selected users."
    head -n 31 users.txt | tail -n 30 > userlist.txt
    c=0
    var1="user"
    var2=":var"
    varname="username="

    cat users.txt | while read line
    do
        let c=c+1
        echo "" >> ansible/inventory
        echo [$var1$c$var2] >> ansible/inventory
        echo $varname$line | xargs >> ansible/inventory
    done
fi

cd ansible
ansible-playbook -i inventory playbook-login-random-users.yml
cd ..

echo ""
echo ""
echo "Action complete."
echo ""
