#!/bin/bash
echo "Enter elastic username: "
read elasticuser

echo "Enter elastic password: "
read elasticpass

if [[ $(curl -k -u $elasticuser:$elasticpass --write-out '%{http_code}' --silent --output /dev/nul -XGET https://172.17.60.40:5601/status -I) != 200 ]];
then
  echo "Invalid username or password. Please check and retry."
  exit
fi

sed -i "s/elastic_user_in_vta/$elasticuser/g" ansible/roles/windows/winlogbeat/files/winlogbeat.yml
sed -i "s/elastic_password_in_vta/$elasticpass/g" ansible/roles/windows/winlogbeat/files/winlogbeat.yml

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
ansible-playbook -i inventory playbook-winlogbeat.yml
curl -u $elasticuser:$elasticpass -k -X POST "https://172.17.60.40:5601/api/index_patterns/index_pattern" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
{
  "index_pattern": {
     "title": "winlogbeat-*"
  }
}
'
echo ""
echo ""
echo "Action complete."
echo ""
cd ..