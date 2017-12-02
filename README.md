# vedetta (alpha)
*Open*BSD Router Boilerplate

![Vedetta Logo](https://avatars2.githubusercontent.com/u/29383850)
## About
> an opinionated, best practice, vanilla OpenBSD base configuration for bare-metal, or cloud routers

What would an OpenBSD router configured using examples from the OpenBSD FAQ and Manual pages look like?

## Features
Share what you've got, keep what you need:
* [acme-client](https://man.openbsd.org/acme-client) - Automatic Certificate Management Environment (ACME) client
  - *Configure:*
    - [`etc/acme`](src/etc/acme)
    - [`etc/acme/acme-client.conf`](src/etc/acme/acme-client.conf)
    - [`etc/httpd.conf`](src/etc/httpd.conf)
    - [`etc/pf.conf`](src/etc/pf.conf)
    - [`etc/relayd.conf`](src/etc/relayd.conf)
    - [`etc/ssl/acme`](src/etc/ssl/acme)
    - [`var/cron/tabs/root`](src/var/cron/tabs/root)
    - `var/www/htdocs/acme`
    - [`var/www/htdocs/freedns.afraid.org`](src/var/www/htdocs/freedns.afraid.org)
  - *Usage:*
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`acme-client`](https://man.openbsd.org/acme-client)` -vAD freedns.afraid.org`
    - [`usr/local/bin/get-ocsp.sh`](src/usr/local/bin/get-ocsp.sh)` freedns.afraid.org`
* [authpf](https://man.openbsd.org/authpf) - authenticating gateway user shell
  - *Configure:*
    - [`etc/authpf`](src/tc/authpf)
    - [`etc/login.conf`](src/etc/login.conf)
    - [`etc/pf.conf`](src/etc/pf.conf)
    - [`etc/ssh/sshd_config`](src/etc/ssh/sshd_config)
  - *Usage:*
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`rcctl`](https://man.openbsd.org/rcctl)` reload sshd`
    - [`ssh`](https://man.openbsd.org/ssh)` hauth@freedns.afraid.org`
* [dhclient](https://man.openbsd.org/dhclient) - Dynamic Host Configuration Protocol (DHCP) client
  - *Configure:*
    - [`etc/dhclient.conf`](src/etc/dhclient.conf)
    - [`etc/hostname.em0`](src/etc/hostname.em0)
    - [`etc/pf.conf`](src/etc/pf.conf)
  - *Usage:*
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`sh`](https://man.openbsd.org/sh)` /etc/netstart em0` *or*
    - [`dhclient`](https://man.openbsd.org/dhclient)` em0`
* [dhcpd](https://man.openbsd.org/dhcpd) - Dynamic Host Configuration Protocol (DHCP) server
  - *Configure:*
    - [`etc/dhcpd.conf`](src/etc/dhcpd.conf)
    - [`etc/pf.conf`](src/etc/pf.conf)
  - *Usage:*
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`rcctl`](https://man.openbsd.org/rcctl)` set dhcpd flags \"athn0 em1 em2\"`
    - [`rcctl`](https://man.openbsd.org/rcctl)` start dhcpd`
* (optional) [wide-dhcpv6](https://github.com/openbsd/ports/tree/master/net/wide-dhcpv6) - client and server for the WIDE DHCPv6 protocol
  - *Configure:*
    - [`etc/dhcp6s.conf`](src/etc/dhcp6s.conf)
    - `etc/dhcp6c.conf`
    - [`etc/pf.conf`](src/etc/pf.conf)
    - [`etc/rc.d/dhcp6c`](src/etc/rc.d/dhcp6c)
    - [`etc/rc.d/dhcp6s`](src/etc/rc.d/dhcp6s)
  - *Usage:*
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`rcctl`](https://man.openbsd.org/rcctl)` set dhcp6s flags \"-c /etc/dhcp6s.conf -dD -k /etc/dhcp6sctlkey em1\"`
    - [`rcctl`](https://man.openbsd.org/rcctl)` start dhcp6s`
* [ftp-proxy](https://man.openbsd.org/ftp-proxy) - Internet File Transfer Protocol proxy daemon
  - *Configure:*
    - [`etc/pf.conf`](src/etc/pf.conf)
  - *Usage:*
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`rcctl`](https://man.openbsd.org/rcctl)` set ftp-proxy flags \"-b 10.10.10.10 -T FTP_PROXY\"`
    - [`rcctl`](https://man.openbsd.org/rcctl)` set ftp-proxy6 flags \"-b fd80:1fe9:fcee:1337::ace:face -T FTP_PROXY6\"`
    - [`rcctl`](https://man.openbsd.org/rcctl)` start ftp-proxy ftp-proxy6`
* [hostname.if](https://man.openbsd.org/hostname.if) - interface-specific configuration files with Dual IP stack implementation
  - *Configure:*
    - [`etc/hostname.athn0`](src/etc/hostname.athn0)
    - [`etc/hostname.em0`](src/etc/hostname.em0)
    - [`etc/hostname.em1`](src/etc/hostname.em1)
    - [`etc/hostname.em2`](src/etc/hostname.em2)
    - [`etc/hostname.enc1`](src/etc/hostname.enc1)
    - [`etc/hostname.gif0`](src/etc/hostname.gif0)
    - [`etc/hostname.tun0`](src/etc/hostname.tun0)
    - [`etc/hostname.vether0`](src/etc/hostname.vether0)
  - *Usage:*
    - `sh /etc/netstart`
* [httpd](https://man.openbsd.org/httpd) - HTTP daemon as primary, fallback, and [autoinstall](https://man.openbsd.org/autoinstall)
  - *Configure:*
    - [`etc/httpd.conf`](src/etc/httpd.conf)
    - [`etc/newsyslog.conf`](src/etc/newsyslog.conf)
    - [`etc/pf.conf`](src/etc/pf.conf)
    - [`etc/ssl/acme/freedns.afraid.org.fullchain.pem`](src/etc/ssl/acme/freedns.afraid.org.fullchain.pem)
    - [`etc/ssl/acme/freedns.afraid.org.ocsp.resp.der`](src/etc/ssl/acme/freedns.afraid.org.ocsp.resp.der)
    - [`etc/ssl/acme/private/freedns.afraid.org.key`](src/etc/ssl/acme/private/freedns.afraid.org.key)
    - [`var/www/htdocs`](src/var/www/htdocs)
  - *Usage:*
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`pfctl`](https://man.openbsd.org/pfctl)` reload syslogd`
    - [`rcctl`](https://man.openbsd.org/rcctl)` enable httpd`
    - [`rcctl`](https://man.openbsd.org/rcctl)` start httpd`
* [ifstated](https://man.openbsd.org/ifstated) - Interface State daemon to reconnect, update IP, and log
  - *Configure:*
    - [`etc/ifstated.conf`](src/etc/ifstated.conf)
  - *Usage:*
    - [`rcctl`](https://man.openbsd.org/rcctl)` enable ifstated`
    - [`rcctl`](https://man.openbsd.org/rcctl)` start ifstated`
* IKEv2 VPN (IPv4 and IPv6)
  - *Configure:*
    - `etc/iked`
    - [`etc/iked.conf`](src/etc/iked.conf)
    - [`etc/iked-vedetta.conf`](src/etc/iked-vedetta.conf)
    - [`etc/pf.conf`](src/etc/pf.conf)
    - `etc/ssl/ikeca.cnf`
    - `etc/ssl/vedetta`
  - *Usage:*
    - [`ikectl`](https://man.openbsd.org/ikectl)` ca vedetta create`
    - [`ikectl`](https://man.openbsd.org/ikectl)` ca vedetta install`
    - [`ikectl`](https://man.openbsd.org/ikectl)` ca vedetta certificate freedns.afraid.org create`
    - [`ikectl`](https://man.openbsd.org/ikectl)` ca vedetta certificate freedns.afraid.org install`
    - [`ikectl`](https://man.openbsd.org/ikectl)` ca vedetta certificate mobile.vedetta.lan create`
    - `cd /etc/iked/export`
    - [`ikectl`](https://man.openbsd.org/ikectl)` ca vedetta certificate mobile.vedetta.lan export`
    - `tar -C /etc/iked/export -xzpf mobile.vedetta.lan.tgz`
    - [`ikectl`](https://man.openbsd.org/ikectl)` ca vedetta certificate mobile.vedetta.lan revoke`
    - [`ikectl`](https://man.openbsd.org/ikectl)` ca vedetta key mobile.vedetta.lan delete`
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`rcctl`](https://man.openbsd.org/rcctl)` set iked flags \"-6\"`
    - [`rcctl`](https://man.openbsd.org/rcctl)` start iked`
* IKEv1 VPN (IPv4)
  - *Configure:*
    - `etc/isakmpd` 
    - [`etc/ipsec.conf`](src/etc/ipsec.conf)
    - [`etc/ipsec-vedetta.conf`](src/etc/ipsec-vedetta.conf)
    - [`etc/npppd`](src/etc/npppd)
    - [`etc/pf.conf`](src/etc/pf.conf)
    - `etc/ssl/ikeca.cnf` 
    - `etc/ssl/vedetta` 
  - *Usage:*
    - [`ikectl`](https://man.openbsd.org/ikectl)` ca vedetta create`
    - [`ikectl`](https://man.openbsd.org/ikectl)` ca vedetta install /etc/isakmpd`
    - [`ikectl`](https://man.openbsd.org/ikectl)` ca vedetta certificate freedns.afraid.org create`
    - [`ikectl`](https://man.openbsd.org/ikectl)` ca vedetta certificate freedns.afraid.org install /etc/isakmpd`
    - [`ikectl`](https://man.openbsd.org/ikectl)` ca vedetta certificate mobile.vedetta.lan create`
    - `cd /etc/isakmpd/export`
    - [`ikectl`](https://man.openbsd.org/ikectl)` ca vedetta certificate mobile.vedetta.lan export`
    - `tar -C /etc/isakmpd/export -xzpf mobile.vedetta.lan.tgz`
    - [`ikectl`](https://man.openbsd.org/ikectl)` ca vedetta certificate mobile.vedetta.lan revoke`
    - [`ikectl`](https://man.openbsd.org/ikectl)` ca vedetta key mobile.vedetta.lan delete`
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`rcctl`](https://man.openbsd.org/rcctl)` enable ipsec npppd`
    - [`rcctl`](https://man.openbsd.org/rcctl)` set isakmpd flags \"-K\"`
    - [`rcctl`](https://man.openbsd.org/rcctl)` start npppd isakmpd`
    - [`ipsecctl`](https://man.openbsd.org/ipsecctl)` -d -f /etc/ipsec-vedetta.conf`
* [nsd](https://man.openbsd.org/nsd) - Name Server Daemon (NSD) as authoritative DNS nameserver for LAN
  - *Configure:*
    - [`etc/pf.conf`](src/etc/pf.conf)
    - [`var/nsd`](src/var/nsd)
  - *Usage:*
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`rcctl`](https://man.openbsd.org/rcctl)` set nsd flags \"-c /var/nsd/etc/nsd.conf\"`
    - [`rcctl`](https://man.openbsd.org/rcctl)` start nsd`
* [ntpd](https://man.openbsd.org/ntpd) - Network Time Protocol daemon
  - *Configure:*
    - [`etc/ntpd.conf`](src/etc/ntpd.conf)
    - [`etc/pf.conf`](src/etc/pf.conf)
  - *Usage:*
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`rcctl`](https://man.openbsd.org/rcctl)` enable ntpd`
    - [`rcctl`](https://man.openbsd.org/rcctl)` start ntpd`
* [pf](https://man.openbsd.org/pf) - packet filter with IP based adblock
  - *Configure:*
    - [`etc/pf.conf`](src/etc/pf.conf)
    - [`var/cron/tabs/root`](src/var/cron/tabs/root)
  - *Usage:*
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`pfctl`](https://man.openbsd.org/pfctl)` -vvs queue`
    - [`pfctl`](https://man.openbsd.org/pfctl)` -s info`
    - [`pfctl`](https://man.openbsd.org/pfctl)` -s states`
    - [`pfctl`](https://man.openbsd.org/pfctl)` -vvs rules`
    - [`pfctl`](https://man.openbsd.org/pfctl)` -v -s rules -R 4`
    - [`pfctl`](https://man.openbsd.org/pfctl)` -s memory`
    - `tcpdump -n -e -ttt -r /var/log/pflog`
    - `tcpdump -neq -ttt -i pflog0`
* [rebound](https://man.openbsd.org/rebound) - DNS proxy
  - *Configure:*
    - [`etc/pf.conf`](src/etc/pf.conf)
    - [`etc/resolv.conf`](src/etc/resolv.conf)
  - *Usage:*
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - `dig ipv6.google.com aaaa`
* [relayd](https://man.openbsd.org/relayd) - relay daemon for loadbalancing, SSL/TLS acceleration, and DNS-sanitizing
  - *Configure:*
    - [`etc/pf.conf`](src/etc/pf.conf)
    - [`etc/relayd.conf`](src/etc/relayd.conf)
  - *Usage:*
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`rcctl`](https://man.openbsd.org/rcctl)` enable relayd`
    - [`rcctl`](https://man.openbsd.org/rcctl)` start relayd`
* [rtadvd](https://man.openbsd.org/rtadvd) - router advertisement daemon
  - *Configure:*
    - [`etc/pf.conf`](src/etc/pf.conf)
    - [`etc/rtadvd.conf`](src/etc/rtadvd.conf)
  - *Usage:*
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`rcctl`](https://man.openbsd.org/rcctl)` set rtadvd flags \"athn0 em1 em2\"`
    - [`rcctl`](https://man.openbsd.org/rcctl)` start rtadvd`
* [sshd](https://man.openbsd.org/sshd) - OpenSSH SSH daemon with internal-sftp
  - *Configure:*
    - [`etc/pf.conf`](src/etc/pf.conf)
    - [`etc/ssh`](src/etc/ssh)
  - *Usage:*
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`rcctl`](https://man.openbsd.org/rcctl)` start sshd`
* [syslogd](https://man.openbsd.org/syslogd) - log system messages
  - *Configure:*
    - [`etc/newsyslog.conf`](src/etc/newsyslog.conf)
    - [`var/cron/tabs/root`](src/var/cron/tabs/root)
  - *Usage:*
    - [`rcctl`](https://man.openbsd.org/rcctl)` set syslogd flags \"\${syslogd_flags} -a /var/unbound/dev/log -a /var/nsd/dev/log\"`
    - [`rcctl`](https://man.openbsd.org/rcctl)` start syslogd`
* [unbound]() - Unbound DNS validating resolver from root nameservers, with caching and DNS based adblock
  - *Configure:*
    - [`etc/pf.conf`](src/etc/pf.conf)
    - [`var/cron/tabs/root`](src/var/cron/tabs/root)
    - [`var/unbound`](src/var/unbound)
  - *Usage:*
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`rcctl`](https://man.openbsd.org/rcctl)` set unbound flags \"-v -c /var/unbound/etc/unbound.conf\"`
    - [`rcctl`](https://man.openbsd.org/rcctl)` start unbound`

Sysadmin:
* [crontab](https://man.openbsd.org/crontab) - maintain crontab files for individual users
  - *Configure:*
    - [`var/cron`](src/var/cron)
  - *Usage:*
    - [`crontab`](https://man.openbsd.org/crontab)` -e`
* [doas](https://man.openbsd.org/doas) - execute commands as another user
  - *Configure:*
    - [`etc/doas.conf`](src/etc/doas.conf)
  - *Usage:*
    - [`doas`](https://man.openbsd.org/doas)` tmux`
* [ftp](https://man.openbsd.org/ftp) - Internet file transfer program
  - *Configure:*
    - [`etc/pf.conf`](src/etc/pf.conf)
  - *Usage:*
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`ftp`](https://man.openbsd.org/ftp)` "https://www.openbsd.org/index.html"`
* [mail](https://man.openbsd.org/mail) - send and receive mail, for daily reading
  - *Usage:*
    - [`mail`](https://man.openbsd.org/mail)
* [syspatch](https://man.openbsd.org/syspatch) - manage base system binary patches
  - *Configure:*
    - `etc/installurl`
    - [`var/cron/tabs/root`](src/var/cron/tabs/root)
  - *Usage:*
    - [`syspatch`](https://man.openbsd.org/syspatch)` -c`
* [systat](https://man.openbsd.org/systat) - display system statistics
  - *Usage:*
    - [`systat`](https://man.openbsd.org/systat)` queues`
    - [`systat`](https://man.openbsd.org/systat)` pf`
    - [`systat`](https://man.openbsd.org/systat)` states`
    - [`systat`](https://man.openbsd.org/systat)` rules`
* [tmux](https://man.openbsd.org/tmux) - terminal multiplexer
  - *Configure:*
    - `~/.tmux.conf`
  - *Usage:*
    - [`tmux`](https://man.openbsd.org/tmux)

## Hardware
OpenBSD likes small form factor, low power, lots of ECC memory, AES-NI support, open source boot, and the fastest supported network cards. This configuration has been tested on [APU2](https://pcengines.ch/apu2c4.htm).

## Install
Encryption is the easiest method for media sanitization and disposal. For this reason, it is recommended to use [full disk encryption](https://www.openbsd.org/faq/faq14.html#softraidFDE).

## SSL
It's best practice to create CAs on a single purpose secure machine, with no network access.

Specify which certificate authorities (CAs) are allowed to issue certificates for your domain, by adding [DNS Certification Authority Authorization (CAA)](https://tools.ietf.org/html/rfc6844) Resource Record (RR) to [`var/nsd/zones/master/vedetta.lan.zone`](src/var/nsd/zones/master/vedetta.lan.zone)

Revoke certificates as often as possible.

## SSH

[SSH fingerprints verified by DNS](http://man.openbsd.org/ssh#VERIFYING_HOST_KEYS) is done by adding Secure Shell (Key) Fingerprint (SSHFP) Resource Record (RR) to [`var/nsd/zones/master/vedetta.lan.zone`](src/var/nsd/zones/master/vedetta.lan.zone): `ssh-keygen -r vedetta.lan.`  
Verify: `dig -t SSHFP vedetta.lan`  
Usage: `ssh -o "VerifyHostKeyDNS ask" acolyte.vedetta.lan`

Manage keys with [ssh-agent](https://man.openbsd.org/ssh-agent).

## Firewall
Guests can use the DNS nameserver to access the ad-free web, while authenticated users gain desired permissions. It's best to authenticate an IP after connecting to VPN. There are three users in this one person example: one for wheel, one for sftp, and one for authpf.

## Performance
Consider using [mount_mfs](https://man.openbsd.org/mount_mfs) in order to reduce wear and tear, as well as to speed up the system. Remember to set the [sticky bit](https://man.openbsd.org/chmod.1#1000) on mfs /tmp, as shown in [etc/fstab](src/etc/fstab).

## Caveats
* VPN with IKEv2 or IKEv1, not both. *While there are many tecnologies for VPN, only IKEv2 and IKEv1 are standard (considerable effort was put into testing and securing)*
* OpenIKED is close to supporting the strongSwan Android client
* relayd does not ocsp, yet
* 11n is max WiFi mode, [is this enough?](https://arstechnica.com/information-technology/2017/03/802-eleventy-what-a-deep-dive-into-why-wi-fi-kind-of-sucks/)
* authpf users have sftp access

## Support
Via [issues](https://github.com/vedetta-com/vedetta/issues) and #openbsd:matrix.org

## Contribute
Show us your fork!

