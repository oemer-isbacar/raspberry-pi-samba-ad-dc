# Phase 3 – DNS-Konfiguration

## Ziel

Sicherstellen dass der interne DNS korrekt funktioniert. Der Pi selbst ist DNS-Server für die Domain `muellerig.local`. Ohne funktionierenden DNS kann kein Windows-Client der Domain beitreten.

---

## 3.1 DNS-Auflösung testen

```bash
host -t SRV _kerberos._udp.muellerig.local
host -t SRV _ldap._tcp.muellerig.local
host -t A dc01.muellerig.local
```

Erwartete Ausgaben:

```
_kerberos._udp.muellerig.local has SRV record 0 100 88 dc01.muellerig.local.
_ldap._tcp.muellerig.local has SRV record 0 100 389 dc01.muellerig.local.
dc01.muellerig.local has address 192.168.20.10
```

---

## 3.2 systemd-resolved deaktivieren

systemd-resolved kann mit Sambas DNS-Backend kollidieren. Deaktivieren:

```bash
sudo systemctl disable systemd-resolved
sudo systemctl stop systemd-resolved
sudo rm /etc/resolv.conf
```

Neue `resolv.conf` anlegen:

```bash
sudo nano /etc/resolv.conf
```

Inhalt:

```
nameserver 192.168.20.10
search muellerig.local
```

Datei gegen Überschreiben sperren:

```bash
sudo chattr +i /etc/resolv.conf
```

---

## 3.3 Kerberos testen

```bash
kinit administrator@MUELLERIG.LOCAL
klist
```

Nach Passworteingabe sollte ein Ticket ausgestellt werden:

```
Credentials cache: FILE:/tmp/krb5cc_0
        Principal: administrator@MUELLERIG.LOCAL

  Issued                Expires               Principal
Jun 12 10:00:00 2026  Jun 12 20:00:00 2026  krbtgt/MUELLERIG.LOCAL@MUELLERIG.LOCAL
```

---

## 3.4 DNS-Weiterleitung an OPNsense

Damit Clients im VLAN 20 auch externe Namen auflösen können, wird eine Weiterleitung konfiguriert.

In `/etc/samba/smb.conf` unter `[global]` ergänzen:

```ini
dns forwarder = 192.168.20.1
```

Dann Samba neu starten:

```bash
sudo systemctl restart samba-ad-dc
```

---

## Ergebnis

- DNS-SRV-Records sind korrekt
- Kerberos-Ticket kann ausgestellt werden
- Externe DNS-Anfragen werden an OPNsense weitergeleitet
- Weiter mit [Phase 4 – Windows-Client Domainbeitritt](04-domainbeitritt.md)
