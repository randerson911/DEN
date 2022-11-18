# This was forked from the main brain of the COBRA DEN. I have not created any of this. I am modifying it for personal use and experimentation.
### Main things I'm looking to do. Learn ansible.
### Secondary Objective. Make a more customized range with the tools available.
## COBRA DEN Quick Configuration Scripts
Ansible Scripts for COBRA DEN configurations instructions.

1. SSH into guac using command `ssh cobra@10.255.255.253`

2. Clone this repo using command `git clone https://github.com/randerson911/cobraden.git`

3. *(Update) Scripts have been updated to prompt for credentials.*

4. run command `cd cobraden && chmod +x *.sh`

5. run config script and enter valid credentials.


### Use in the Kibana Dev Tools
`POST /_security/api_key
    {
        "name": "fleet_host001", 
        "role_descriptors": {
            "filebeat_writer": { 
            "cluster": ["monitor", "read_ilm", "read_pipeline"],
            "index": [
            {
                "names": ["*"],
                "privileges": ["view_index_metadata", "create_doc"]
            }
            ]
        }
    }
}`

  1. Copy the API key that you get from the results

  2. Add to the Fleet Settings
output.elasticsearch:
    hosts: ["https://172.17.60.40:9200"]
    api_key: "<API Key>"