import argparse
import subprocess
import shutil

_apt_updated = False

DEPENDENCIES = {
    "nmap": "nmap",
    "masscan": "masscan",
    "whois": "whois",
    "ip": "iproute2",
    "ifconfig": "net-tools",
    "curl": "curl",
    "tor": "tor",
    "hostname": "hostname",
}


def ensure_command(cmd: str, package: str) -> bool:
    """Ensure command exists, attempting apt installation if missing."""
    global _apt_updated
    if shutil.which(cmd):
        return True
    print(f"{cmd} not found. Attempting to install {package}...")
    try:
        if not _apt_updated:
            subprocess.run(["sudo", "apt-get", "update"], check=True)
            _apt_updated = True
        subprocess.run(["sudo", "apt-get", "install", "-y", package], check=True)
    except Exception as exc:
        print(f"Failed to install {package}: {exc}")
        return False
    return shutil.which(cmd) is not None


def check_all_deps():
    """Ensure all known dependencies are installed."""
    for cmd, pkg in DEPENDENCIES.items():
        ensure_command(cmd, pkg)


def run_nmap(target: str, ports: str = ""):
    """Run nmap against target. Ports may be provided as comma separated list."""
    if not ensure_command("nmap", "nmap"):
        return
    cmd = ["nmap", "-sS", target]
    if ports:
        cmd.extend(["-p", ports])
    try:
        subprocess.run(cmd, check=True)
    except FileNotFoundError:
        print("nmap is not installed or not in PATH")
    except subprocess.CalledProcessError as exc:
        print(f"nmap failed: {exc}")


def run_masscan(target: str, ports: str = "1-65535", rate: str = ""):
    """Run masscan fast port scan."""
    if not ensure_command("masscan", "masscan"):
        return
    cmd = ["sudo", "masscan", target, "-p", ports]
    if rate:
        cmd.extend(["--rate", rate])
    try:
        subprocess.run(cmd, check=True)
    except FileNotFoundError:
        print("masscan is not installed or not in PATH")
    except subprocess.CalledProcessError as exc:
        print(f"masscan failed: {exc}")


def whois_lookup(domain: str):
    """Perform a WHOIS lookup for the given domain."""
    if not ensure_command("whois", "whois"):
        return
    try:
        subprocess.run(["whois", domain], check=True)
    except FileNotFoundError:
        print("whois command not found")
    except subprocess.CalledProcessError as exc:
        print(f"whois failed: {exc}")


def change_mac(interface: str, new_mac: str):
    """Change MAC address using `ip` when available with fallback to `ifconfig`."""
    try:
        if ensure_command("ip", "iproute2"):
            subprocess.run(["sudo", "ip", "link", "set", interface, "down"], check=True)
            subprocess.run([
                "sudo",
                "ip",
                "link",
                "set",
                interface,
                "address",
                new_mac,
            ], check=True)
            subprocess.run(["sudo", "ip", "link", "set", interface, "up"], check=True)
        elif ensure_command("ifconfig", "net-tools"):
            subprocess.run(["sudo", "ifconfig", interface, "down"], check=True)
            subprocess.run([
                "sudo",
                "ifconfig",
                interface,
                "hw",
                "ether",
                new_mac,
            ], check=True)
            subprocess.run(["sudo", "ifconfig", interface, "up"], check=True)
        else:
            print("Neither ip nor ifconfig is available")
            return
        print(f"MAC for {interface} changed to {new_mac}")
    except FileNotFoundError as exc:
        print(f"Required command not found: {exc}")
    except subprocess.CalledProcessError as exc:
        print(f"Failed to change MAC: {exc}")


def my_ip():
    """Print public IP using external service."""
    if not ensure_command("curl", "curl"):
        return
    try:
        out = subprocess.check_output(["curl", "-s", "https://api.ipify.org"])
        print(out.decode().strip())
    except FileNotFoundError:
        print("curl not found")
    except subprocess.CalledProcessError as exc:
        print(f"Failed to get IP: {exc}")


def local_ip():
    """Print local IP addresses."""
    if not ensure_command("hostname", "hostname"):
        return
    try:
        out = subprocess.check_output(["hostname", "-I"])
        print(out.decode().strip())
    except FileNotFoundError:
        print("hostname command not found")
    except subprocess.CalledProcessError as exc:
        print(f"Failed to get local IP: {exc}")


def _service(cmd):
    """Try running command list, ignoring missing executables."""
    if not ensure_command(cmd[1], cmd[1]):
        return False
    try:
        subprocess.run(cmd, check=True)
        return True
    except FileNotFoundError:
        return False
    except subprocess.CalledProcessError as exc:
        print(f"Command {' '.join(cmd)} failed: {exc}")
        return False


def tor_start():
    """Start tor service."""
    if not ensure_command("tor", "tor"):
        print("tor not available")
        return
    if _service(["sudo", "systemctl", "start", "tor"]):
        print("Tor started with systemctl")
    elif _service(["sudo", "service", "tor", "start"]):
        print("Tor started with service")
    else:
        print("Failed to start tor: systemctl/service not available")


def tor_stop():
    """Stop tor service."""
    if not ensure_command("tor", "tor"):
        print("tor not available")
        return
    if _service(["sudo", "systemctl", "stop", "tor"]):
        print("Tor stopped with systemctl")
    elif _service(["sudo", "service", "tor", "stop"]):
        print("Tor stopped with service")
    else:
        print("Failed to stop tor: systemctl/service not available")


def main(argv=None):
    parser = argparse.ArgumentParser(description="Blueshift - modern pentest toolkit")
    sub = parser.add_subparsers(dest="cmd", required=True)

    recon = sub.add_parser("recon", help="Run basic nmap scan")
    recon.add_argument("target", help="Target IP or domain")
    recon.add_argument("--ports", help="Port list e.g. 80,443")

    mscan = sub.add_parser("masscan", help="Run masscan fast scan")
    mscan.add_argument("target", help="Target IP or CIDR")
    mscan.add_argument("--ports", default="1-65535", help="Port range")
    mscan.add_argument("--rate", help="Packets per second")

    mac = sub.add_parser("mac", help="Change MAC address")
    mac.add_argument("interface", help="Interface name")
    mac.add_argument("new_mac", help="New MAC address")

    who = sub.add_parser("whois", help="WHOIS lookup")
    who.add_argument("domain", help="Domain name")

    sub.add_parser("myip", help="Show public IP")
    sub.add_parser("localip", help="Show local IP addresses")
    sub.add_parser("tor-start", help="Start tor service")
    sub.add_parser("tor-stop", help="Stop tor service")
    sub.add_parser("deps", help="Install required dependencies")

    args = parser.parse_args(argv)

    if args.cmd == "recon":
        run_nmap(args.target, args.ports or "")
    elif args.cmd == "masscan":
        run_masscan(args.target, args.ports, args.rate or "")
    elif args.cmd == "mac":
        change_mac(args.interface, args.new_mac)
    elif args.cmd == "myip":
        my_ip()
    elif args.cmd == "localip":
        local_ip()
    elif args.cmd == "tor-start":
        tor_start()
    elif args.cmd == "tor-stop":
        tor_stop()
    elif args.cmd == "deps":
        check_all_deps()
    elif args.cmd == "whois":
        whois_lookup(args.domain)
    else:
        parser.print_help()


if __name__ == "__main__":
    main()
