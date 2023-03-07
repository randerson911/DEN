#!/usr/bin/env python3

import os

# Define the functions for each task
def task1():
    playbook_dir = './playbooks/production/'
    playbook_file = 'playbook-cobra-den.yml'

    cmd = 'ansible-playbook ' + playbook_dir + playbook_file
    subprocess.call(cmd.split())


def task2():
    print("Running task 2...")

def task3():
    print("Running task 3...")

# Define the main menu function
def main_menu():
    os.system('clear')
    welcomeText = """
    Welcome to the Cobra Den Ansible Configuration
    Please choose a task you would like to accomplish
    1. Install Everything (playbook-cobra-den.yml)
    2. Install VSCode and Python (playbook-operator-setup.yml)
    3. Install Elastic and Winlogbeat (playbook-siem-info.yml)
    4. Configure TAPS and Login Random Users (playbook-traffic.yml)
    5. Configure the Elastic Indexes (playbook-indexes.yml)
    0. Exit
    """
    print(welcomeText)

    choice = input("> ")
    if choice == "1":
        task1()
    elif choice == "2":
        task2()
    elif choice == "3":
        task3()
    elif choice == "5":
        task4()
    elif choice == "5":
        task5()
    elif choice == "0":
        print("Goodbye!")
        exit(0)
    else:
        input("Invalid choice. Press enter to try again...")
    main_menu()

# Call the main menu function
main_menu()
