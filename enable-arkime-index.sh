#!/bin/bash

curl -u elastic_user_in_vta:elastic_password_in_vta -k -X POST "https://172.17.60.40:5601/api/index_patterns/index_pattern" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
{
  "index_pattern": {
     "title": "arkime*"
  }
}
'
echo ""
echo ""
echo "Action complete."
echo ""