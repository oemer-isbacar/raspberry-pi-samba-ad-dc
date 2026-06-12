#!/bin/bash
# status.sh – schnelle Übersicht über den Samba AD DC

echo "=== Samba AD DC Status ==="
echo ""

echo "--- Dienst ---"
systemctl is-active samba-ad-dc && echo "samba-ad-dc: AKTIV" || echo "samba-ad-dc: INAKTIV"
echo ""

echo "--- Domain Level ---"
samba-tool domain level show 2>/dev/null | grep "function level"
echo ""

echo "--- Benutzer ---"
samba-tool user list 2>/dev/null
echo ""

echo "--- Computer in der Domain ---"
samba-tool computer list 2>/dev/null
echo ""

echo "--- DNS SRV Records ---"
host -t SRV _ldap._tcp.muellerig.local 127.0.0.1 2>/dev/null
host -t SRV _kerberos._udp.muellerig.local 127.0.0.1 2>/dev/null
echo ""

echo "--- Kerberos Ticket ---"
klist 2>/dev/null || echo "Kein aktives Ticket (kinit administrator@MUELLERIG.LOCAL)"
