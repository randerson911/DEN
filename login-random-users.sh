#!/bin/bash

if [ -f users.txt ]
then
    echo "It looks like you already have a list of users."
    echo "Do you wish to generate a new one?"
    echo ""
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) rm -f users.txt; break;;
            No ) break;;
        esac
    done
fi

if [ ! -f umarker.txt ]
then
    echo ""
    echo "Important: If you encounter errors in the ansible output, it will most likely be"
    echo "credentials related. Please ensure you are providing the Windows credentials in"
    echo "the following prompts. Delete the umarker.txt and input the correct values."
    echo ""

    echo "Enter Windows admin username: "
    read denuser

    echo "Enter Windows admin password: "
    read denpass

    sed -i "/den_user:/c\den_user: $denuser" ansible/group_vars/all/vars.yml
    sed -i "/den_user_password:/c\den_user_password: $denpass" ansible/group_vars/all/vars.yml
    echo "Complete." > umarker.txt
fi

if [ ! -f users.txt ]
then
    cd ansible
    ansible-playbook -i inventory playbook-get-random-users.yml
    cd ..
    sed -i 's/[^[:print:]]//g' users.txt
    sed -i '/^$/d' users.txt
    sed -i '1d' users.txt
    sed -r -i 's/\s+//g' users.txt
    cat users.txt
fi

if [ ! -f lmarker.txt ]
then

    if grep -q "user1:vars" ansible/inventory
    then
        lnr=$(sed -n '/##marker/=' ansible/inventory)
        sed -i "1, $lnr ! d" ansible/inventory
    fi

    echo ""
    echo "Modify inventory file and integrate selected users."

    c=0
    var1="user"
    var2=":vars"
    varname="uname="

    cat users.txt | while read line
    do
        let c=c+1
        echo "" >> ansible/inventory
        echo [$var1$c$var2] >> ansible/inventory
        echo $varname$line >> ansible/inventory
    done
    echo "Complete." > lmarker.txt
fi

cd ansible
ansible-playbook -i inventory playbook-login-random-users.yml
cd ..

echo ""
echo ""
echo "Action complete."
echo ""
