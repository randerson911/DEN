#!/bin/bash

echo "Enter elastic username: "
read elasticuser

echo "Enter elastic password: "
read elasticpass

curl -u $elasticuser:$elasticpass -k -X POST "https://172.17.60.40:5601/api/index_patterns/index_pattern" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
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