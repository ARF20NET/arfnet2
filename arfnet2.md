# ARFNET2 deployment

Stage 1, very safe
 - Close all ports
 - Nuke (or stop) all old VMs (exclude OPNSense)
 - Make DMZ
 - Make the following ones (cloning deb12 template)
 - Open following ports

## Networks
 - DMZ untagged 192.168.4.0/24: Services and management
 - LAN VLAN 5   192.168.5.0/24: Clients
 - VPN LAN      10.5.0.0/24: Wireguard clients

## Hosts
 - server (...)
 - desktop .8
 - raspi .14

## Management
 - server iDRAC .5
 - Proxmox .4
 - OPNSense .1
 - switch .2
 - WAP .3
 - printer .7

## VMs and services
All VMs must run the wazuh agent

### OPNSense .1
 - (routing)
 - SSH
 - DHCP
 - unbound DNS
 - OpenVPN
 - WireGuard
 - IPsec

### NAS .6
RAID attached here (with the grey stuff) (local only)
 - SSH
 - NFS
 - Samba SMB
 - MiniDLNA
 - qBittorrent-nox

### web .9
 - SSH
 - nginx (static only site, isolated from NAS)

### wazuh .10
 - SSH
 - wazuh

### comm .11
 - SSH
 - postfix/dovecot mail (not)
 - IRC
 - XMPP
 - matrix instance
 - asterisk VoIP SIP

## Port forwards
 - SSH -> somewhere possibly not a machine with services just to be sure?
 - OpenVPN -> opnsense
 - HTTP/S -> web

## Name and Number Assignation Table
| A | Host | Name |
|---|------|------|
| 1 | gateway | router.lan |
| 2 | switch | switch.lan |
| 3 | wap | wap.lan |
| 4 | proxmox | proxmox.lan |
| 5 | R720 iDRAC | idrac.lan |
| 6 | nas | nas.lan |
| 7 | printer | printer.lan |
| 8 | desktop | desktop.lan |
| 9 | webserver | web.lan |
| 10 | wazuh | wazuh.lan |
| 11 | comm | comm.lan |