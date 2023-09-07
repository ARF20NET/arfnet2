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
 - DNS
 - OpenVPN
 - IPsec

### NAS .9
RAID attached here (with the grey stuff) (local only)
 - SSH
 - NFS
 - Samba
 - DLNA
 - qBittorrent-nox

### wazuh .10
 - SSH
 - wazuh

### web .6
 - SSH
 - nginx (static only site, isolated from NAS)

## Port forwards
 - SSH -> somewhere possibly not a machine with services just to be sure?
 - OpenVPN -> opnsense
 - HTTP/S -> web

