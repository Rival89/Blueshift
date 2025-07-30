#!/bin/bash

#==============================================================================
#
#                           LALIN (LAZY LINUX)
#
# Lalin is a bash-based framework for automating penetration testing tasks in
# Kali Linux. It provides a menu-driven interface for managing tools,
# running scripts, and streamlining workflows.
#
# Author: Edooo-maland
# Forked and improved by: Your Name
#
#==============================================================================

# --- Colors ---
CYAN='\e[0;36m'
GREEN='\e[0;34m'
OKGREEN='\033[92m'
LIGHTGREEN='\e[1;32m'
WHITE='\e[1;37m'
RED='\e[1;31m'
YELLOW='\e[1;33m'

# --- Globals ---
GIT_CLONE='git clone -q --depth 1'

# --- UI Functions ---

function print_banner() {
    clear
    echo -e "${RED}"
    echo " LLLLL      AAAA      LL       IIIIII     NN     NN"
    echo " LL         AA  AA     LL         II       NNN    NN"
    echo " LL         AAAAAA     LL         II       NN NN  NN"
    echo " LL         AA  AA     LL         II       NN  NN NN"
    echo " LLLLLL     AA  AA     LLLLLL   IIIIII     NN   NNNN"
    echo -e "${WHITE}"
}

function print_main_menu() {
    print_banner
    echo -e "================================================="
    echo -e "          ${CYAN}LAZY LINUX TOOLKIT ${RED}v2.0"
    echo -e "================================================="
    echo -e " ${YELLOW}1)${WHITE} Tool Management"
    echo -e " ${YELLOW}2)${WHITE} Automation Scripts"
    echo -e " ${YELLOW}3)${WHITE} System Utilities"
    echo -e " ${YELLOW}4)${WHITE} Exit"
    echo -e "================================================="
    echo
}

# Pause function
function pause() {
    echo -e "${CYAN}"
    read -sn 1 -p "Press any key to continue..."
}

# Error message function
function ngerusuhlo() {
    clear
    echo -e "${WHITE}Invalid option. Please try again."
    pause
    clear
}

# --- Main Menu ---
function main_menu() {
    while true; do
        print_main_menu
        read -p "Enter your choice: " choice
        case $choice in
            1)
                tool_management_menu
                ;;
            2)
                automation_scripts_menu
                ;;
            3)
                system_utilities_menu
                ;;
            4)
                clear
                exit 0
                ;;
            *)
                ngerusuhlo
                ;;
        esac
    done
}

# --- Tool Management Menu ---
function tool_management_menu() {
    clear
    echo -e "${WHITE}============================================="
    echo -e "% ${CYAN}Tool Management${WHITE} %"
    echo -e "============================================="
    echo
    echo -e "${WHITE}"
    select opt in "Install New Tools" "Remove Existing Tools" "Update Installed Tools" "Back to Main Menu"; do
        case $opt in
            "Install New Tools")
                install_new_tools_menu
                ;;
            "Remove Existing Tools")
                remove_existing_tools_menu
                ;;
            "Update Installed Tools")
                update_installed_tools_menu
                ;;
            "Back to Main Menu")
                main_menu
                ;;
            *)
                ngerusuhlo
                ;;
        esac
    done
}

# --- Automation Scripts Menu ---
function automation_scripts_menu() {
    clear
    echo -e "${WHITE}============================================="
    echo -e "% ${CYAN}Automation Scripts${WHITE} %"
    echo -e "============================================="
    echo
    echo -e "${WHITE}"
    select opt in "Run Reconnaissance Scripts" "Run Exploitation Scripts" "Run Post-Exploitation Scripts" "Back to Main Menu"; do
        case $opt in
            "Run Reconnaissance Scripts")
                run_reconnaissance_scripts_menu
                ;;
            "Run Exploitation Scripts")
                run_exploitation_scripts_menu
                ;;
            "Run Post-Exploitation Scripts")
                run_post_exploitation_scripts_menu
                ;;
            "Back to Main Menu")
                main_menu
                ;;
            *)
                ngerusuhlo
                ;;
        esac
    done
}

# --- System Utilities Menu ---
function system_utilities_menu() {
    clear
    echo -e "${WHITE}============================================="
    echo -e "% ${CYAN}System Utilities${WHITE} %"
    echo -e "============================================="
    echo
    echo -e "${WHITE}"
    select opt in "Update Kali Linux" "Fix Common Issues" "Back to Main Menu"; do
        case $opt in
            "Update Kali Linux")
                # Add function to update Kali Linux
                ;;
            "Fix Common Issues")
                # Add function to fix common issues
                ;;
            "Back to Main Menu")
                main_menu
                ;;
            *)
                ngerusuhlo
                ;;
        esac
    done
}

# --- Install New Tools Menu ---
function install_new_tools_menu() {
    clear
    echo -e "${WHITE}============================================="
    echo -e "% ${CYAN}Install New Tools${WHITE} %"
    echo -e "============================================="
    echo
    echo -e "${WHITE}"
    select opt in "Install Recon-ng" "Install Metasploit Framework" "Install Burp Suite" "Back to Tool Management"; do
        case $opt in
            "Install Recon-ng")
                install_recon_ng
                ;;
            "Install Metasploit Framework")
                install_metasploit
                ;;
            "Install Burp Suite")
                install_burp_suite
                ;;
            "Back to Tool Management")
                tool_management_menu
                ;;
            *)
                ngerusuhlo
                ;;
        esac
    done
}

# --- Remove Existing Tools Menu ---
function remove_existing_tools_menu() {
    clear
    echo -e "${WHITE}============================================="
    echo -e "% ${CYAN}Remove Existing Tools${WHITE} %"
    echo -e "============================================="
    echo
    echo -e "${WHITE}"
    select opt in "Remove Recon-ng" "Remove Metasploit Framework" "Remove Burp Suite" "Back to Tool Management"; do
        case $opt in
            "Remove Recon-ng")
                remove_recon_ng
                ;;
            "Remove Metasploit Framework")
                remove_metasploit
                ;;
            "Remove Burp Suite")
                remove_burp_suite
                ;;
            "Back to Tool Management")
                tool_management_menu
                ;;
            *)
                ngerusuhlo
                ;;
        esac
    done
}

# --- Update Installed Tools Menu ---
function update_installed_tools_menu() {
    clear
    echo -e "${WHITE}============================================="
    echo -e "% ${CYAN}Update Installed Tools${WHITE} %"
    echo -e "============================================="
    echo
    echo -e "${WHITE}"
    select opt in "Update Recon-ng" "Update Metasploit Framework" "Update Burp Suite" "Back to Tool Management"; do
        case $opt in
            "Update Recon-ng")
                update_recon_ng
                ;;
            "Update Metasploit Framework")
                update_metasploit
                ;;
            "Update Burp Suite")
                update_burp_suite
                ;;
            "Back to Tool Management")
                tool_management_menu
                ;;
            *)
                ngerusuhlo
                ;;
        esac
    done
}

# --- Tool Installation Functions ---

function install_recon_ng() {
    echo "Installing Recon-ng..."
    apt-get install -y recon-ng
    pause
}

function install_metasploit() {
    echo "Installing Metasploit Framework..."
    apt-get install -y metasploit-framework
    pause
}

function install_burp_suite() {
    echo "Installing Burp Suite..."
    apt-get install -y burpsuite
    pause
}

# --- Tool Removal Functions ---

function remove_recon_ng() {
    echo "Removing Recon-ng..."
    apt-get remove -y recon-ng
    pause
}

function remove_metasploit() {
    echo "Removing Metasploit Framework..."
    apt-get remove -y metasploit-framework
    pause
}

function remove_burp_suite() {
    echo "Removing Burp Suite..."
    apt-get remove -y burpsuite
    pause
}

# --- Tool Update Functions ---

function update_recon_ng() {
    echo "Updating Recon-ng..."
    apt-get install --only-upgrade -y recon-ng
    pause
}

function update_metasploit() {
    echo "Updating Metasploit Framework..."
    apt-get install --only-upgrade -y metasploit-framework
    pause
}

function update_burp_suite() {
    echo "Updating Burp Suite..."
    apt-get install --only-upgrade -y burpsuite
    pause
}

# --- Automation Script Menus ---

function run_reconnaissance_scripts_menu() {
    clear
    echo -e "${WHITE}============================================="
    echo -e "% ${CYAN}Reconnaissance Scripts${WHITE} %"
    echo -e "============================================="
    echo
    echo -e "${WHITE}"
    select opt in "Nmap Scan" "Subdomain Enumeration" "Back to Automation Scripts"; do
        case $opt in
            "Nmap Scan")
                run_nmap_scan
                ;;
            "Subdomain Enumeration")
                run_subdomain_enumeration
                ;;
            "Back to Automation Scripts")
                automation_scripts_menu
                ;;
            *)
                ngerusuhlo
                ;;
        esac
    done
}

function run_exploitation_scripts_menu() {
    clear
    echo -e "${WHITE}============================================="
    echo -e "% ${CYAN}Exploitation Scripts${WHITE} %"
    echo -e "============================================="
    echo
    echo -e "${WHITE}"
    select opt in "Search for Exploits" "Generate Shellcode" "Back to Automation Scripts"; do
        case $opt in
            "Search for Exploits")
                search_for_exploits
                ;;
            "Generate Shellcode")
                generate_shellcode
                ;;
            "Back to Automation Scripts")
                automation_scripts_menu
                ;;
            *)
                ngerusuhlo
                ;;
        esac
    done
}

function run_post_exploitation_scripts_menu() {
    clear
    echo -e "${WHITE}============================================="
    echo -e "% ${CYAN}Post-Exploitation Scripts${WHITE} %"
    echo -e "============================================="
    echo
    echo -e "${WHITE}"
    select opt in "Privilege Escalation" "Maintain Access" "Back to Automation Scripts"; do
        case $opt in
            "Privilege Escalation")
                privilege_escalation
                ;;
            "Maintain Access")
                maintain_access
                ;;
            "Back to Automation Scripts")
                automation_scripts_menu
                ;;
            *)
                ngerusuhlo
                ;;
        esac
    done
}

# --- Automation Script Functions ---

function run_nmap_scan() {
    echo "Running Nmap scan..."
    # Add Nmap scan script here
    pause
}

function run_subdomain_enumeration() {
    echo "Running subdomain enumeration..."
    # Add subdomain enumeration script here
    pause
}

function search_for_exploits() {
    echo "Searching for exploits..."
    # Add exploit search script here
    pause
}

function generate_shellcode() {
    echo "Generating shellcode..."
    # Add shellcode generation script here
    pause
}

function privilege_escalation() {
    echo "Running privilege escalation script..."
    # Add privilege escalation script here
    pause
}

function maintain_access() {
    echo "Running maintain access script..."
    # Add maintain access script here
    pause
}

# --- Main ---
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

while true; do
    main_menu
done
