#!/bin/bash

if [ ! -f ansible/.vault_pass ]
then
    echo "Please enter the vault password: "
    read -s vault_pass

    echo $vault_pass > ./ansible/.vault_pass
    chmod 0600 ./ansible/.vault_pass
fi

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


if [ ! -f users.txt ]
then
    cd ansible
    ansible-playbook -i inventory.yml --vault-password-file ./.vault_pass playbook-get-random-users.yml
    cd ..
    sed -i 's/[^[:print:]]//g' users.txt
    sed -i '/^$/d' users.txt
    sed -i '1d' users.txt
    sed -r -i 's/\s+//g' users.txt
    cat users.txt
fi


#!/bin/bash

if [ ! -f lmarker.txt ]; then
  cd ansible
  lpass=$(ansible-vault view --vault-password-file ./.vault_pass cobra.vault | grep linux_user_password | cut -d ' ' -f 2)
  cd ..

pip3 install pyyaml

python3 ./login-random-users.py ./ansible/inventory.yml users.txt

fi



# if [ ! -f lmarker.txt ]
# then

#     if grep -q "user1:vars" ansible/inventory.yml
#     then
#         lnr=$(sed -n '/##marker/=' ansible/inventory.yml)
#         sed -i "1, $lnr ! d" ansible/inventory.yml
#     fi

#     echo ""
#     echo "Modify inventory file and integrate selected users."

#     c=0
#     var1="user"
#     var2=":vars"
#     varname="uname="

#     cat users.txt | while read line
#     do
#         let c=c+1
#         echo "" >> ansible/inventory.yml
#         echo [$var1$c$var2] >> ansible/inventory.yml
#         echo $varname$line >> ansible/inventory.yml
#     done
#     echo "Complete." > lmarker.txt
# fi

cd ansible
ansible-playbook -i inventory.yml --vault-password-file ./.vault_pass playbook-login-random-users.yml
cd ..

echo ""
echo ""
echo "Action complete."
echo ""
