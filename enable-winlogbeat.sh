#!/bin/bash

if [ ! -f ansible/.vault_pass ]
then
    echo "Please enter the vault password: "
    read vault_pass

    echo $vault_pass > ansible/.vault_pass
    chmod 0600 /ansible/.vault_pass
fi

if [ ! -f elmarker.txt ]
then
  echo "Enter elastic username: "
  read elasticuser

  echo "Enter elastic password: "
  read elasticpass

  if [[ $(curl -k -u $elasticuser:$elasticpass --write-out '%{http_code}' --silent --output /dev/nul -XGET https://172.17.60.40:5601/status -I) != 200 ]];
  then
    echo "Invalid Elasticsearch username or password. Please check and retry."
    exit
  fi

  sed -i "s/elastic_user_in_vta/$elasticuser/g" ansible/roles/windows/winlogbeat/files/winlogbeat.yml
  sed -i "s/elastic_password_in_vta/$elasticpass/g" ansible/roles/windows/winlogbeat/files/winlogbeat.yml
  echo $elasticuser:$elasticpass > elmarker.txt
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

#     sed -i "/den_user:/c\den_user: $denuser" ansible/group_vars/all/vars.yml
#     sed -i "/den_user_password:/c\den_user_password: $denpass" ansible/group_vars/all/vars.yml
#     echo "Complete." > umarker.txt
# fi

cd ansible
ansible-playbook -i inventory --vault-password-file ./.vault_pass playbook-winlogbeat.yml
cd ..

creds=$(cat elmarker.txt)
curl -u $creds -k -X POST "https://172.17.60.40:5601/api/index_patterns/index_pattern" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
{
  "index_pattern": {
     "title": "winlogbeat-*",
     "timeFieldName": "@timestamp"
  }
}
'
echo ""
echo ""
echo "Action complete."
echo ""