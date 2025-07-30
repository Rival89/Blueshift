# Blueshift

Blueshift is the spiritual successor to the original **LaLin** pentest toolkit. It provides a modern, modular framework to automate common pre‑operation tasks. Individual commands are exposed via a Python CLI while a gum‑powered menu offers an intuitive interface.

## Features

* Python based command line interface
* Basic recon wrapper around `nmap`
* Fast port scanning via `masscan`
* Domain information with `whois`
* Simple MAC address changer (uses `ip` or `ifconfig`)
* Networking helpers (public IP, local IP)
* Tor control helpers
* Gum powered interactive menu
* Automatic dependency installation

The goal is to expand Blueshift with additional modules in the future. Contributions and pull requests are welcome!

## Architecture

Core tasks are implemented in Python under the `blueshift` package.  The
`blueshift.sh` script provides an interactive interface using Charmbracelet’s
`gum`.  It presents nested menus for recon, network actions and Tor control.
Each option ultimately calls the Python CLI so functionality can also be used
non-interactively.

## Usage

```bash
python -m blueshift recon 192.168.0.1
python -m blueshift masscan 192.168.0.1 --ports 80-443 --rate 1000
python -m blueshift mac eth0 00:11:22:33:44:55
python -m blueshift myip
python -m blueshift whois example.com
python -m blueshift tor-start
python -m blueshift deps   # install dependencies
./blueshift.sh
```

`blueshift.sh` launches a gum-powered pre‑operation framework with submenus for
recon, network actions and Tor control. Use it to drive common tasks without
typing lengthy commands.
The Python CLI will attempt to install missing tools (via `apt`) the first time
they are needed. Ensure you have sudo rights. Required tools include `nmap`,
`iproute2` (or `net-tools` for `ifconfig`), `curl`, `masscan`, `whois`, and `tor`.
