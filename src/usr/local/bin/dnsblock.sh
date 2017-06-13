#!/bin/sh
# https://www.filters.com
# https://github.com/StevenBlack/hosts
# https://deadc0de.re/articles/unbound-blocking-ads.html
# https://pgl.yoyo.org/adservers/serverlist.php?hostformat=unbound&showintro=0&mimetype=plaintext

#set -eu
set -o errexit
set -o nounset

PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin

app=$(basename $0)
AWK=/usr/bin/awk
FTP=/usr/bin/ftp
CAT=/bin/cat
GREP=/usr/bin/grep
EGREP=/usr/bin/egrep
SORT=/usr/bin/sort
PFCTL=/sbin/pfctl
RM=/bin/rm
CP=/bin/cp
CHMOD=/bin/chmod
TR=/usr/bin/tr
RCCTL=/usr/sbin/rcctl

hostsurl="https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"

tmp=/tmp
 
hoststmp="${hostsurl##*/}".tmp
dnsblock=dnsblock.conf
unboundchroot=/var/unbound

error_exit () {
    echo "${app}: ${1:-"Unknown Error"}" 1>&2
    exit 1
}

# Bail out if non-privileged UID
[ 0 = "$(id -u)" ] || \
    error_exit "$LINENO: ERROR: You are using a non-privileged account."

# Mise en place
"${RM}" -rf "${tmp}"/"${hoststmp}" "${tmp}"/"${dnsblock}"

# Download
"${FTP}" -o "${tmp}"/"${hoststmp}" "${hostsurl}" || \
    error_exit "$LINENO: ERROR: download failed."

# Convert hosts to unbound.conf
"${CAT}" "${tmp}"/"${hoststmp}" | "${GREP}" '^0\.0\.0\.0' | \
    "${AWK}" '{print "local-zone: \""$2"\" redirect\nlocal-data: \""$2" A 0.0.0.0\""}' > \
    "${tmp}"/"${dnsblock}"

# Install
"${RM}" -rf "${unboundchroot}"/etc/"${dnsblock}"
"${CP}" "${tmp}"/"${dnsblock}" "${unboundchroot}"/etc/ || \
    error_exit "$LINENO: ERROR: ${dnsblock} copy failed."
"${CHMOD}" 600 "${unboundchroot}"/etc/"${dnsblock}" || exit

# Populate unbound dns block
#[ $("${CAT}" "${unboundchroot}"/etc/unbound.conf | grep "${dnsblock}") ] && echo "Loading ${dnsblock}"
"${RCCTL}" stop unbound
"${RCCTL}" start unbound || \
    error_exit "$LINENO: ERROR: unbound failed."

# Remove temp files
"${RM}" -rf "${tmp}"/"${hoststmp}" "${tmp}"/"${dnsblock}"
