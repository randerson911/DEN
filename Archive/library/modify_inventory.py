from ansible.module_utils.basic import AnsibleModule
import yaml

def modify_inventory(inventory_path, names_file_path):
    with open(names_file_path, 'r') as names_file:
        names = [line.strip() for line in names_file]

    with open(inventory_path, 'r') as inventory_file:
        inventory = yaml.safe_load(inventory_file)

    for i, name in enumerate(names, start=1):
        if i <= 10:
            subnet = 'subnet1'
        elif i <= 20:
            subnet = 'subnet2'
        else:
            subnet = 'subnet3'
        user = 'user{}'.format(i)
        if subnet not in inventory['windows']['children']:
            inventory['windows']['children'][subnet] = {'children': {}}
        if user not in inventory['windows']['children'][subnet]['children']:
            inventory['windows']['children'][subnet]['children'][user] = {'hosts': {}}
        inventory['windows']['children'][subnet]['children'][user]['vars'] = {'uname': name}

    with open(inventory_path, 'w') as inventory_file:
        yaml.dump(inventory, inventory_file, default_flow_style=False)

def main():
    module = AnsibleModule(
        argument_spec=dict(
            inventory_path=dict(type='path', required=True),
            names_file_path=dict(type='path', required=True)
        ),
        supports_check_mode=False
    )

    inventory_path = module.params['inventory_path']
    names_file_path = module.params['names_file_path']

    modify_inventory(inventory_path, names_file_path)

    module.exit_json(changed=True)

if __name__ == '__main__':
    main()
