# ARFNET2 deployment
After the disastrous ISP [schism](http://arf20.com/explanation.txt)

## Masterplan
Stage 1: very safe
 - Close all ports
 - Nuke (or stop) all old VMs (exclude OPNSense)
 - Make DMZ
 - Make new basic VMs (cloning deb12 template)
 - Open basic ports

Stage 2: new services
 - IONOS VPS for mail
 - Some new very safe services
 - HE IPv6 tunnel
 - Own authoritative nameservers for domain zone

Stage 3*: finally
 - Another VPS in unknown provider for
    - Tor
    - Reverse-proxying the media library
 - PHP on main site with more web services from scratch, hopefully secure
 - More new services

## Domain
arf20.com <br>
Registrar: namecheap

### Name sever glue records at registrar
| Nameserver | Name | IP |
|------------|------|----|
| NS1 | ns1.arf20.com | 2.59.235.35 <br> 2001:470:1f21:125::13 |
| NS2 | ns2.arf20.com | 5.250.186.185 <br> 2001:ba0:210:d600::1 |

## Networking
### Public IPs
 - AVANZA: 2.59.235.35
 - HE v6 tunnel: 2001:470:1f20:125::2
 - IONOS VPS: 5.250.186.185  2001:ba0:210:d600::1

### Gateways
 - AVANZA: 2.59.235.1
 - HE v6: 2001:470:1f20:125::1 via 216.66.87.102

### Networks
| name | VLAN | net | desc |
|------|------|-----|------|
| DMZ  | untagged | 192.168.4.0/24 <br> 2001:470:1f21:125::/64 | Services 
| LAN  | 5    | 192.168.5.0/24 |  Clients
| VPN  |      | 10.5.0.0/24 | Wireguard clients

### Hardware
```
                 +-------------+
       +-----+   | eno1 server |
ISP ===| ONT |---|   router    |
       +-----+   |    eno2     |
                 +-------------+
                        |
                 +-------------+
                 | DELL 5424   |
                 +-------------+
                   |        |
         5x TP-LINK Sw   Rest of hosts
              |
      Living room devices
                   
- 1000BASE-T
= GPON fiber
```

## Hosts
 - server - DELL PowerEdge R720 running Proxmox PVE - ...
 - mail -  IONOS VPS running Debian 12 - 5.250.186.185  2001:ba0:210:d600::1

## Management
 - OPNSense router DMZ.1
 - DELL switch DMZ.2
 - TP-L WAP LAN.3
 - Proxmox hypervisor DMZ.4
 - DELL server iDRAC DMZ.5
 - HP printer DMZ.7

## server VMs and services
server runs Proxmox PVE. 
All VMs are Debian 12 (templated) with wazuh agent

### proxmox DMZ.4 (hypervisor)
 - SSH
 - Proxmox management interface :8006
 - smartd*
 - SMART exporter*
 - IPMI exporter*
 - sensor exporter*
 - NUT - Network UPS TOols daemon (and proper UPS)*

### router DMZ.1
 - (routing/firewalling)
 - SSH
 - DHCP
 - unbound DNS
 - OpenVPN
 - WireGuard
 - IPsec*
 - ntopng :3000

### nas DMZ.6
RAID attached here (with the grey stuff) (local only)
 - SSH
 - NFS
 - Samba SMB*
 - MiniDLNA*
 - FTP
 - qBittorrent-nox
 - jellyfin

### web DMZ.9
 - SSH
 - cerbot
 - nginx (status at :8080)
 - fastcgi PHP
 - mariadb SQL
 - nginx-prometheus-exporter :9113
 - prometheus :9090
 - telegraf
 - influxdb :8086
 - grafana :3000
    - Proxmox
    - nginx
    - iDRAC
 - zabbix*
 - netbox*
 - fcgiwrap
 - git-http-backend - git smart http server CGI
 - gitd - git daemon
 - cgit - web frontend for git
 - phpBB*
 - Jekyll - blog static site generator thing

| vhost | webroot/proxy | Comment |
|-------|---------------|---------|
| default | <return 418 im a teapot> | |
| default:8080 | \<return nstub_status> | |
| arf20.com | /var/www/arf20.com/html/ | |
| www.arf20.com | <301 redirect arf20.com> | |
| matrix.arf20.com | http://comm.lan:8008/_matrix | |
| webmail.arf20.com | /var/www/webmail.arf20.com/html/ | SquirrelMail |
| nextcloud.arf20.com | /var/www/nextcloud.arf20.com/html/ | |
| grafana.arf20.com | http://localhost:3000 | |
| jellyfin.arf20.com | http://nas.lan:8096 | |
| git.arf20.com | /srv/git/ | |
| cgit.arf20.com | fastcgi:/usr/lib/cgit/cgit.cgi | |
| blog.arf20.com | /var/www/blog.arf20.com/_site/ | |

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
 - asterisk - VoIP SIP PBX

### misc (Deb12 LXC) DMZ.13
 - SSH
 - iperf3
 - bind9 - master authoritative nameserver for arf20.com zone NS1
 - OpenLDAP LDAP*

### mail (ARFNET-IONOS VPS) 5.250.186.185 2001:ba0:210:d600::1
 - SSH
 - certbot
 - postfix - MTA smtpd, submission, submissions
    [config](https://github.com/ARF20NET/mail-conf)
 - dovecot - imapd
 - bind9 - slave authoritative nameserver NS2

 ### proxy (ARFNET-HOSTMENOW VPS) *
 - SSH*
 - IPsec client*
 - proxy for ftp.arf20.com somehow*

---

### yerovps DMZ.192 (yero)
 - SSH
 - mariadb
 - FiveM SuperioresRP

### exovps DMZ.195 (exo)
 - SSH
 - netbox

*TODO

## Firewall
### IPv4 NAT Port forwards
 | Service | Customer | IPProto | Ext Port | Host | Re Port |
 |---------|----------|---------|----------|------|---------|
 | OpenVPN | | TCP | 1195 | router | |
 | WireGuard | | UDP | 51820 | router | |
 | DNS NS1 | | TCP/UDP | 53 | misc | |
 | Web     | | TCP | 80,443 | web | |
 | Git     | | TCP | 9418 | web | |
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

### IPv6 port rules
 | Service | Customer | IPProto | Host | Port |
 |---------|----------|---------|------|------|
 | DNS NS1 | | TCP/UDP | misc | 53 |
 | Web     | | TCP | web | 80,443 |

## Internal Name and Number Assignation Table
DMZ IPv4s and IPv6 ends in the same way
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
| DMZ.195 | exovps | exo.lan |

## Domain DNS zone
| Name | Type | Content | Comment |
|------|------|---------|---------|
| arf20.com | NS | ns1.arf20.com | |
| arf20.com | NS | ns2.arf20.com | |
| ns1 | A | 2.59.235.35 | |
| ns1 | AAAA | 2001:470:1f21:125::13 | |
| ns2 | A | 5.250.186.185 | |
| ns2 | AAAA | 2001:ba0:210:d600::1 | |
| arf20.com | A | 2.59.235.35 | |
| arf20.com | AAAA | 2001:470:1f21:125::9 | |
| arf20.com | MX | mail.arf20.com | |
| mail | A | 5.250.186.185 | |
| mail | AAAA | 2001:ba0:210:d600::1 | |
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

## HE v6 rDNS zone
| Name | Type | Content | Comment |
|------|------|---------|---------|
| 2001:470:1f21:125::13 | PTR | ns1.arf20.com | |
| 2001:470:1f21:125::9  | PTR | arf20.com | |

## IONOS rDNS zone
| Name | Type | Content | Comment |
|------|------|---------|---------|
| 5.250.186.185 | PTR | mail.arf20.com | |
