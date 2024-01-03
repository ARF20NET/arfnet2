# ARFNET2 deployment
After the disastrous ISP [schism](http://arf20.com/explanation.txt)

## Masterplan
Stage 1, very safe
 - Close all ports
 - Nuke (or stop) all old VMs (exclude OPNSense)
 - Make DMZ
 - Make new basic VMs (cloning deb12 template)
 - Open basic ports

Stage 2, new services
 - IONOS VPS for mail
 - Some new very safe services

Stage 3*, finally
 - Another VPS in unknown provider for
    - Tor
    - Reverse-proxying the media library
 - PHP on main site with more web services from scratch, hopefully secure
 - More new services
 - Our own authoritative nameserver for the domain zone

## Networks
 - DMZ untagged 192.168.4.0/24: Services and management
 - LAN VLAN 5   192.168.5.0/24: Clients
 - VPN LAN      10.5.0.0/24: Wireguard clients

## Hosts
 - server DMZ(...)
 - mail (ARFNET-IONOS) 5.250.186.185

## Management
 - DELL server iDRAC .5
 - Proxmox hypervisor .4
 - OPNSense router .1
 - DELL switch .2
 - TP-L WAP .3
 - HP printer .7

## VMs and services
All VMs are Debian 12 (templated) with wazuh agent

### router DMZ.1
 - (routing/firewalling)
 - SSH
 - DHCP
 - unbound DNS
 - OpenVPN
 - WireGuard
 - IPsec*

### nas DMZ.6
RAID attached here (with the grey stuff) (local only)
 - SSH
 - NFS
 - Samba SMB*
 - MiniDLNA*
 - qBittorrent-nox
 - jellyfin*

### web DMZ.9
 - SSH
 - cerbot
 - nginx
 - fastcgi PHP
 - mariadb SQL

| vhost | webroot/proxy |
|-------|---------------|
| default | <return 418 im a teapot> |
| arf20.com | /var/www/arf20.com/html/ |
| www.arf20.com | <301 redirect arf20.com> |
| matrix.arf20.com | http://comm.lan:8008/_matrix |
| webmail.arf20.com | /var/www/webmail.arf20.com/html/ |
| nextcloud.arf20.com | /var/www/nextcloud.arf20.com/html/ |

### wazuh DMZ.10
 - SSH
 - wazuh

### game DMZ.11
 - SSH
 - waterfall (minecraft reverse proxy)
    - mclobby (auth)
    - mcrubenmc
    - mcgrupo4*
    - minepau*
 - csgo server*

### comm DMZ.12
 - SSH
 - cerbot
 - unrealircd - IRC
 - synapse - matrix
 - postgresql - DB for synapse
 - pantalaimon - encrypt matterbridge traffic to matrix
 - matterbridge - bridge channels with different protocols
 - prosody - XMPP
 - coturn - TURN server for matrix and xmpp
 - asterisk - VoIP SIP*

### misc (Deb12 LXC) DMZ.13
 - SSH
 - iperf3
 - bind9 - authoritative DNS server for arf20.com zone*

### mail (ARFNET-IONOS) 5.250.186.185
 - SSH
 - certbot
 - postfix - MTA smtpd, submission, submissions
    [config](https://github.com/ARF20NET/mail-conf)
 - dovecot - imapd

### yerovps DMZ.192 (yero)
 - SSH
 - mariadb
 - FiveM SuperioresRP

*TODO

## Port forwards
 | Service | Customer | IPProto | Ext Port | Host | Re Port |
 |---------|----------|---------|----------|------|---------|
 | OpenVPN | | TCP | 1195 | router | |
 | WireGuard | | UDP | 51820 | router | |
 | Web     | | TCP | 80,443 | web | |
 | bittorrent | | TCP/UDP | 8999 | nas | |
 | IRC     | | TCP | 6667 | comm | |
 | IRCS    | | TCP | 6697 | comm | |
 | XMPP c2s| | TCP | 5222 | comm | |
 | XMPP s2s| | TCP | 5269 | comm | |
 | TURN STUN| | TCP/UDP | 3478 | comm | |
 | TURN    | | TCP/UDP | 5349 | comm | |
 | TURN UDP relay| | TCP/UDP | 49152-50176 | comm | |
 | grupo4mc| | TCP | 25565 | game | |
 | rubenmc | | TCP | 25566 | game | |
 | | | | | | |
 | yero-SSH | yero | TCP | 1511 | yerovps | 22 | |
 | yero-SQL | yero | TCP | 1512 | yerovps | 3306 |
 | FiveM SuperioresRP | yero | TCP | 30120,40120 | yerovps | |

## Internal Name and Number Assignation Table
| Addr | Name |
|------|------|
| DMZ.1 |  router.lan |
| DMZ.2 |  switch.lan |
| DMZ.3 |  wap.lan |
| DMZ.4 |  proxmox.lan |
| DMZ.5 |  idrac.lan |
| DMZ.6 |  nas.lan |
| DMZ.7 |  printer.lan |
| DMZ.8 |  desktop.lan |
| DMZ.9 |  web.lan |
| DMZ.10 | wazuh.lan |
| DMZ.11 | game.lan |
| DMZ.12 | comm.lan |
| DMZ.13 | misc.lan |
| | | |
| DMZ.192 | yerovps | yero.lan |

## Public DNS zone
| Name | Type | Content | Comment |
|------|------|---------|---------|
| arf20.com | A | 2.59.235.35 | |
| arf20.com | MX | mail.arf20.com | |
| mail | A | 5.250.186.185 | |
| selector._domainkey | TXT | (DKIM) | DKIM for selector 'selector' |
| _dmarc | TXT | (DMARC) | |
| arf20.com | TXT | (SPF) | |
| www | CNAME | arf20.com |
| jellyfin | CNAME | arf20.com |
| irc | CNAME | arf20.com |
| matrix | CNAME | arf20.com |
| xmpp | CNAME | arf20.com |
| xmppconf | CNAME | arf20.com |
| turn | CNAME | arf20.com |
| nextcloud | CNAME | arf20.com |
| webmail | CNAME | arf20.com |
| _acme-challenge.jellyfin | CNAME | (challenge) | |
| _acme-challenge.irc | CNAME | (challenge) | |
| _acme-challenge.matrix | CNAME | (challenge) | |
| _acme-challenge.mail |  CNAME | (challenge) | |
| _acme-challenge.xmpp |  CNAME | (challenge) | |

## IONOS zone
| Name | Type | Content | Comment |
|------|------|---------|---------|
| 5.250.186.185 | PTR | mail.arf20.com | |
