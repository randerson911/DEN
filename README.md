# COBRA DEN Quick Configuration Scripts
Ansible Scripts for COBRA DEN configurations instructions.

1. SSH into guac using command `ssh cobra@10.255.255.253`

2. Clone this repo using command `git clone https://github.com/PACAF-COBRA/cobraden.git`

~~3. Change username and password placeholders (see_vta_for_value) in the following files:~~

~~* ansible/group_vars/all/vars.yml~~

~~* ansible/role/windows/winlogbeat/files/winlogbeat.yml~~

~~* enable-arkime-index.sh~~

~~* enable-winlogbeat.sh~~

3. *(Update) Scripts have been updated to prompt for credentials.*

4. run command `cd cobraden && chmod +x *.sh`

5. run config script and enter valid credentials.
