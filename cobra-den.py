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
    print("Welcome to the main menu!")
    print("Please choose a task:")
    print("1. Task 1")
    print("2. Task 2")
    print("3. Task 3")
    print("0. Exit")

    choice = input("> ")
    if choice == "1":
        task1()
    elif choice == "2":
        task2()
    elif choice == "3":
        task3()
    elif choice == "0":
        print("Goodbye!")
        exit()
    else:
        input("Invalid choice. Press enter to try again...")
    main_menu()

# Call the main menu function
main_menu()
