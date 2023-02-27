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


if [ ! -f lmarker.txt ]; then
  # check that ansible-vault command and password file exist
  if ! which ansible-vault >/dev/null || ! test -f ansible/.vault_pass; then
    echo "Error: ansible-vault command or password file not found."
    exit 1
  fi

  # get linux user password from vault
  cd ansible
  lpass=$(ansible-vault view --vault-password-file ./.vault_pass cobra.vault | grep linux_user_password | cut -d ' ' -f 2)
  cd ..

  # install yq if not already installed
  if ! pip show yq >/dev/null; then
    echo "Installing the required application [yq] to modify the yaml file"
    pip install yq 2>/dev/null
    if ! pip show yq >/dev/null; then
      echo "Error: yq installation failed."
      exit 1
    fi
  fi

  echo ""
  echo "Modify inventory file and integrate selected users."

  # loop over users and set variable and subnet
  c=0
  while IFS= read -r line; do
    let c=c+1
    section=".windows.children."
    if [ $c -le 10 ]; then
      section+="subnet1.children.user$c.vars"
    elif [ $c -le 20 ]; then
      section+="subnet2.children.user$c.vars"
    else
      section+="subnet3.children.user$c.vars"
    fi
    if ! yq eval "$section.\"uname\" = \"$line\"" -i ansible/inventory.yml; then
      echo "Error: Failed to update inventory file."
      exit 1
    fi
  done < users.txt

  echo "Inventory file updated successfully."
  echo "Complete." > lmarker.txt
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
