# Phase 2 – Samba 4 Installation & AD-Provisionierung

## Ziel

Samba 4 installieren und als Active Directory Domain Controller für die Domain `muellerig.local` provisionieren.

---

## 2.1 Abhängigkeiten installieren

```bash
sudo apt install -y samba krb5-config krb5-user winbind smbclient
```

Während der Installation wird nach dem Kerberos-Realm gefragt:

```
Default Kerberos version 5 realm: MUELLERIG.LOCAL
Kerberos servers for your realm: dc01.muellerig.local
Administrative server for your Kerberos realm: dc01.muellerig.local
```

> Achtung: Der Realm wird immer in Großbuchstaben angegeben.

---

## 2.2 Bestehende Samba-Konfiguration entfernen

```bash
sudo systemctl stop smbd nmbd winbind
sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.bak
```

---

## 2.3 AD Domain Controller provisionieren

```bash
sudo samba-tool domain provision \
  --use-rfc2307 \
  --realm=MUELLERIG.LOCAL \
  --domain=MUELLERIG \
  --server-role=dc \
  --dns-backend=SAMBA_INTERNAL \
  --adminpass='Passwort123!'
```

Parameter erklärt:

| Parameter | Bedeutung |
|---|---|
| `--use-rfc2307` | Aktiviert Unix-Attribute (UID/GID) für Benutzer |
| `--realm` | Kerberos-Realm, immer Großbuchstaben |
| `--domain` | NetBIOS-Name der Domain (kurz) |
| `--server-role=dc` | Dieser Server wird Domain Controller |
| `--dns-backend=SAMBA_INTERNAL` | Samba übernimmt den DNS-Dienst intern |
| `--adminpass` | Passwort für den Domain-Administrator |

> Das Passwort muss Mindestanforderungen erfüllen: Großbuchstaben, Kleinbuchstaben, Ziffern, Sonderzeichen.

---

## 2.4 Kerberos-Konfiguration übernehmen

```bash
sudo cp /var/lib/samba/private/krb5.conf /etc/krb5.conf
```

---

## 2.5 Samba als AD DC starten

```bash
sudo systemctl unmask samba-ad-dc
sudo systemctl enable samba-ad-dc
sudo systemctl start samba-ad-dc
```

Status prüfen:

```bash
sudo systemctl status samba-ad-dc
```

---

## 2.6 Provisionierung testen

```bash
samba-tool domain level show
```

Erwartete Ausgabe (gekürzt):

```
Domain and forest function level for domain 'DC=muellerig,DC=local'

Forest function level: (Windows) 2008 R2
Domain function level: (Windows) 2008 R2
Lowest function level of a DC: (Windows) 2008 R2
```

---

## Ergebnis

- Samba 4 ist installiert und läuft als AD DC
- Domain `muellerig.local` ist bereit
- Kerberos ist konfiguriert
- Weiter mit [Phase 3 – DNS-Konfiguration](03-dns.md)
