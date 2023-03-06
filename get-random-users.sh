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
    echo "It looks like this script has already been run once."
    echo "Do you wish to run it again?"
    echo ""
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) rm -f users.txt; break;;
            No ) break;;
        esac
    done
fi

# if [ ! -f umarker.txt ]
# then
#     echo ""
#     echo "Important: If you encounter errors in the ansible output, it will most likely be"
#     echo "credentials related. Please ensure you are providing the Windows credentials in"
#     echo "the following prompts. Delete the umarker.txt and input the correct values."
#     echo ""

#     echo "Enter Windows admin username: "
#     read denuser

#     echo "Enter Windows admin password: "
#     read denpass

#     sed -i "/den_user:/c\den_user: $denuser" ./group_vars/all/vars.yml
#     sed -i "/den_user_password:/c\den_user_password: $denpass" ./group_vars/all/vars.yml
#     echo "Complete." > umarker.txt
# fi

if [ ! -f users.txt ]
then
    
    ansible-playbook -i inventory/production/inventory.yml --vault-password-file ./cobra.vault playbooks/production/playbook-get-random-users.yml
    
    sed -i 's/[^[:print:]]//g' users.txt
    sed -i '/^$/d' users.txt
    sed -i '1d' users.txt
    sed -r -i 's/\s+//g' users.txt
    cat users.txt
fi

echo ""
echo ""
echo "Action complete."
echo ""
