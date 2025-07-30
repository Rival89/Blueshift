#!/usr/bin/env bash

# Blueshift interactive framework
# Requires gum: https://github.com/charmbracelet/gum

set -e

if ! command -v gum >/dev/null 2>&1; then
    echo "gum is not installed. Please install from https://github.com/charmbracelet/gum" >&2
    exit 1
fi

main_menu() {
    gum style --foreground 212 --bold "Blueshift Pre-Op Framework"
    gum choose "Recon" "Network" "Tor" "Install Deps" "Exit" --header "Select an action"
}

recon_menu() {
    choice=$(gum choose "Nmap Scan" "Masscan" "Whois" "Back" --header "Recon actions")
    case "$choice" in
        "Nmap Scan")
            target=$(gum input --placeholder "target host")
            [ -z "$target" ] && return
            ports=$(gum input --placeholder "ports (optional)")
            if [ -n "$ports" ]; then
                python -m blueshift recon "$target" --ports "$ports"
            else
                python -m blueshift recon "$target"
            fi
            ;;
        "Masscan")
            target=$(gum input --placeholder "target or CIDR")
            [ -z "$target" ] && return
            ports=$(gum input --placeholder "ports e.g. 1-65535")
            rate=$(gum input --placeholder "rate (optional)")
            cmd=(python -m blueshift masscan "$target" --ports "$ports")
            [ -n "$rate" ] && cmd+=(--rate "$rate")
            "${cmd[@]}"
            ;;
        "Whois")
            domain=$(gum input --placeholder "domain")
            [ -n "$domain" ] && python -m blueshift whois "$domain"
            ;;
    esac
}

network_menu() {
    choice=$(gum choose "My IP" "Local IP" "Change MAC" "Back" --header "Network actions")
    case "$choice" in
        "My IP")
            python -m blueshift myip
            ;;
        "Local IP")
            python -m blueshift localip
            ;;
        "Change MAC")
            iface=$(gum input --placeholder "interface e.g. eth0")
            new_mac=$(gum input --placeholder "new MAC e.g. 00:11:22:33:44:55")
            python -m blueshift mac "$iface" "$new_mac"
            ;;
    esac
}

tor_menu() {
    choice=$(gum choose "Start Tor" "Stop Tor" "Back" --header "Tor control")
    case "$choice" in
        "Start Tor") python -m blueshift tor-start ;;
        "Stop Tor") python -m blueshift tor-stop ;;
    esac
}

while true; do
    choice=$(main_menu)
    case "$choice" in
        Recon)
            recon_menu
            ;;
        Network)
            network_menu
            ;;
        Tor)
            tor_menu
            ;;
        "Install Deps")
            python -m blueshift deps
            ;;
        Exit)
            break
            ;;
    esac
    gum confirm "Return to main menu?" || break
    echo
done
