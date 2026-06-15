# Phase 2 – Samba 4 Installation und AD-Provisionierung

## Was in dieser Phase passiert

Samba 4 wird installiert und als Active Directory Domain Controller eingerichtet. Am Ende läuft Samba als Dienst und die Domain ist bereit für Clients.

> Wichtig: Für die Installation braucht der Pi Internetzugang. Da in Phase 1 die eigene IP als DNS eingetragen wurde und Samba noch nicht läuft, kann der Pi noch keine externen Namen auflösen. Den DNS deshalb vor der Installation temporär auf das Gateway setzen:
> ```bash
> sudo nmcli con mod <UUID> ipv4.dns "<Gateway-IP>"
> sudo nmcli con up <UUID>
> ```
> Nach der Installation wird der DNS wieder auf die eigene IP zurückgestellt (Phase 3).

---

## 2.1 Pakete installieren

```bash
sudo apt install -y samba krb5-config krb5-user winbind smbclient
```

Während der Installation erscheinen drei Abfragen zur Kerberos-Konfiguration:

**Abfrage 1 – Default Kerberos realm:**
```
<DOMAIN-NAME>.LOCAL
```

**Abfrage 2 – Kerberos servers for your realm:**
```
dc01.<domain-name>.local
```

**Abfrage 3 – Administrative server for your Kerberos realm:**
```
dc01.<domain-name>.local
```

> Wichtig: Der Realm wird immer in Großbuchstaben angegeben. Das ist Pflicht, sonst schlägt die Kerberos-Authentifizierung später fehl.

---

## 2.2 Bestehende Samba-Konfiguration entfernen

Die Installation legt automatisch eine Standard-`smb.conf` an. Diese muss vor der Provisionierung entfernt werden, da `samba-tool` sonst abbricht.

```bash
sudo systemctl stop smbd nmbd winbind
sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.bak
```

---

## 2.3 Domain provisionieren

```bash
sudo samba-tool domain provision \
  --use-rfc2307 \
  --realm=<DOMAIN-NAME>.LOCAL \
  --domain=<DOMAIN-NAME> \
  --server-role=dc \
  --dns-backend=SAMBA_INTERNAL \
  --adminpass='<sicheres-passwort>'
```

Was die Parameter bedeuten:

| Parameter | Bedeutung |
|---|---|
| `--use-rfc2307` | Aktiviert Unix-Attribute für Benutzer (UID/GID) |
| `--realm` | Kerberos-Realm, immer Großbuchstaben |
| `--domain` | NetBIOS-Name, kurzer Name der Domain |
| `--server-role=dc` | Dieser Server wird Domain Controller |
| `--dns-backend=SAMBA_INTERNAL` | Samba übernimmt den DNS-Dienst selbst |
| `--adminpass` | Passwort für den Domain-Administrator |

Das Passwort muss Großbuchstaben, Kleinbuchstaben, Ziffern und Sonderzeichen enthalten.

Die Provisionierung dauert etwa 30-60 Sekunden. Am Ende erscheint eine Zusammenfassung:

```
Server Role:           active directory domain controller
Hostname:              dc01
NetBIOS Domain:        <DOMAIN-NAME>
DNS Domain:            <domain-name>.local
DOMAIN SID:            S-1-5-21-...
```

---

## 2.4 Kerberos-Konfiguration übernehmen

```bash
sudo cp /var/lib/samba/private/krb5.conf /etc/krb5.conf
```

> Hinweis: Laut Samba-Dokumentation darf diese Datei nicht als Symlink eingebunden werden, sondern muss kopiert werden.

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

Der Dienst sollte `active (running)` zeigen und die Statuszeile `samba: ready to serve connections...` erscheinen.

---

## 2.6 Provisionierung testen

```bash
sudo samba-tool domain level show
```

> Hinweis: Dieser Befehl braucht `sudo`, sonst kommt ein `Permission denied` Fehler.

Erwartete Ausgabe:

```
Forest function level: (Windows) 2008 R2
Domain function level: (Windows) 2008 R2
Lowest function level of a DC: (Windows) 2008 R2
```

---

## Ergebnis

- Samba 4 ist installiert und läuft als AD DC
- Die Domain ist bereit
- Kerberos ist konfiguriert

---

Weiter mit [Phase 3 – DNS](03-dns.md)
