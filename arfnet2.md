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

### router .1
 - (routing/firewalling)
 - SSH
 - DHCP
 - unbound DNS
 - OpenVPN
 - WireGuard
 - IPsec*

### NAS .6
RAID attached here (with the grey stuff) (local only)
 - SSH
 - NFS
 - Samba SMB*
 - MiniDLNA*
 - qBittorrent-nox

### web .9
 - SSH
 - nginx (static only site, isolated from NAS)

| vhost | webroot/proxy |
|-------|---------------|
| arf20.com | /var/www/arf20.com/html/ |
| www.arf20.com | <301 redirect arf20.com> |
| matrix.arf20.com | http://192.168.4.12:8008/_matrix |
| default | <return 418 im a teapot> |


### wazuh .10
 - SSH
 - wazuh

### game .11
 - SSH
 - grupo4mc
 - rubenmc

### comm .12
 - SSH
 - IRC
 - XMPP*
 - matrix instance*
 - asterisk VoIP SIP*

*TODO

## Port forwards
 | Service | Customer | IPProto | Ext Port | Host | Re Port |
 |---------|----------|---------|----------|------|---------|
 | OpenVPN | | TCP | 1194 | router | |
 | WireGuard | | UDP | 51820 | router | |
 | Web     | | TCP | 80,443 | web | |
 | bittorrent | | TCP/UDP | 8999 | nas | |
 | IRC     | | TCP | 6667 | comm | |
 | grupo4mc| | TCP | 25565 | game | |
 | rubenmc | | TCP | 25566 | game | |
 | 
 | yero-SSH | yero | TCP | 1511 | yerovps | 22 | |
 | yero-SQL | yero | TCP | 1512 | yerovps | 3306 |
 | FiveM SuperioresRP | yero | TCP | 30120,40120 | yerovps | |


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
| 11 | game | game.lan |
| 12 | comm | comm.lan |
