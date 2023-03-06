#!/bin/bash

if [ ! -f ./cobra.vault ]
then
    echo "Please enter the vault password: "
    read -s cobra.den

    echo cobra.den > ./cobra.vault
    chmod 0600 ./cobra.vault
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
    
    ansible-playbook -i inventory/production/inventory.yml --vault-password-file ./cobra.vault playbooks/production/playbook-get-random-users.yml
    
    sed -i 's/[^[:print:]]//g' users.txt
    sed -i '/^$/d' users.txt
    sed -i '1d' users.txt
    sed -r -i 's/\s+//g' users.txt
    cat users.txt
fi


#!/bin/bash

if [ ! -f lmarker.txt ]; then
  
  lpass=$(ansible-vault view --vault-password-file ./cobra.vault cobra.vault.yml | grep linux_user_password | cut -d ' ' -f 2)
  

  pip3 install pyyaml
  
  python3 ./login-random-users.py ./ansible/inventory.yml users.txt

  echo "Inventory has been updated to include uname: username vars now."
  echo "Complete!" > lmarker.txt

fi


ansible-playbook -i inventory/production/inventory.yml --vault-password-file ./cobra.vault playbooks/production/playbook-login-random-users.yml


echo ""
echo ""
echo "Action complete."
echo ""
