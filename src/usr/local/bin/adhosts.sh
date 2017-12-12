#!/bin/sh
# Update the adhosts IP list (etc/pf.adhosts) from pgl.yoyo.org

#set -eu
set -o errexit
set -o nounset

PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin

app=$(basename $0)
FTP=/usr/bin/ftp
CAT=/bin/cat
EGREP=/usr/bin/egrep
SORT=/usr/bin/sort
PFCTL=/sbin/pfctl
RM=/bin/rm
CP=/bin/cp
CHMOD=/bin/chmod

adhostsurl="https://pgl.yoyo.org/adservers/iplist.php?ipformat=&showintro=0&mimetype=plaintext"
adhoststmp=$(mktemp) || exit 1
adhosts=$(mktemp) || exit 1
adhostspf=/etc/pf.adhosts

error_exit () {
    echo "${app}: ${1:-"Unknown Error"}" 1>&2
    exit 1
}

# Bail out if non-privileged UID
[ 0 = "$(id -u)" ] || \
    error_exit "$LINENO: ERROR: You are using a non-privileged account."

# Download the adhosts IP list
"${FTP}" -o "${adhoststmp}" "${adhostsurl}" || \
    error_exit "$LINENO: ERROR: Download failed."

# Clean HTML headers and sort the adhosts IP list
"${CAT}" "${adhoststmp}" | \
    "${EGREP}" '([[:digit:]]{1,3}\.){3}[[:digit:]]{1,3}' | \
    "${SORT}" -n > "${adhosts}" || \
    error_exit "$LINENO: ERROR: List processing failed."

# Install
"${RM}" -rf "${adhostspf}"
"${CP}" "${adhosts}" "${adhostspf}" || exit
"${CHMOD}" 600 "${adhostspf}" || exit

# Populate the pf adhosts table
"${PFCTL}" -t adhosts -T replace -f "${adhostspf}" || \
    error_exit "$LINENO: ERROR: pf failed."

# Remove temp files
"${RM}" -rf "${adhoststmp}" "${adhosts}"
