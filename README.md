# Samba 4 Active Directory Domain Controller auf dem Raspberry Pi 4

Dieses Projekt zeigt wie man einen vollwertigen Active Directory Domain Controller auf einem Raspberry Pi 4 betreibt. Als Software kommt Samba 4 zum Einsatz, das die AD-Funktionalität von Windows Server nachbildet. Windows-Clients können der Domain beitreten, Benutzer werden zentral verwaltet und Gruppenrichtlinien werden domainweit verteilt.

---

## Was am Ende funktioniert

- Samba 4 läuft als AD Domain Controller
- DNS funktioniert intern und extern
- Kerberos-Authentifizierung ist aktiv
- Windows-Clients können der Domain beitreten
- Benutzer und Gruppen werden zentral verwaltet
- Gruppenrichtlinien werden auf alle Domain-Mitglieder angewendet

---

## Voraussetzungen

| Was | Details |
|---|---|
| Raspberry Pi 4 | Mindestens 2 GB RAM, empfohlen 4 GB |
| SD-Karte | Mindestens 16 GB, empfohlen 32 GB |
| Betriebssystem | Raspberry Pi OS Lite 64-bit (Debian Bookworm) |
| Netzwerk | LAN-Kabel empfohlen, WLAN funktioniert auch |
| Windows-Client | Windows 10 oder 11 für den Domainbeitritt |

---

## Netzwerk

Pi und Windows-Client müssen im gleichen Netz hängen. Der Pi bekommt eine statische IP, der Windows-Client nutzt ihn als DNS-Server.

```
Router/Firewall (Gateway)
        |
   Raspberry Pi 4
   statische IP: <frei wählbar>
   Hostname: dc01.<domain-name>.local
        |
   Windows-Client
```

> Hinweis: Falls der Pi an einem managed Switch mit VLANs betrieben wird, muss der Switch-Port als **Untagged Access Port** des gewünschten VLANs konfiguriert sein. Der Pi versteht kein VLAN-Tagging.

---

## Projektphasen

| Phase | Inhalt |
|---|---|
| 1 | Systemvorbereitung (Hostname, IP, Zeit) |
| 2 | Samba 4 installieren und Domain aufsetzen |
| 3 | DNS konfigurieren und testen |
| 4 | Windows-Client in die Domain aufnehmen |
| 5 | Benutzer und Gruppen anlegen |
| 6 | Gruppenrichtlinien einrichten |

---

## Dokumentation

- [Phase 1 – Systemvorbereitung](01-vorbereitung.md)
- [Phase 2 – Samba Installation](02-samba-installation.md)
- [Phase 3 – DNS](03-dns.md)
- [Phase 4 – Domainbeitritt](04-domainbeitritt.md)
- [Phase 5 – Benutzer und Gruppen](05-benutzer-gruppen.md)
- [Phase 6 – Gruppenrichtlinien](06-gpo.md)

---

## Verwendete Software

| Software | Zweck |
|---|---|
| Raspberry Pi OS Lite 64-bit (Bookworm) | Basisbetriebssystem |
| Samba 4 | Active Directory Domain Controller |
| MIT Kerberos | Authentifizierung |
| NetworkManager | Netzwerkkonfiguration |

---

## Hinweise

Dieses Projekt dient Lern- und Dokumentationszwecken.

Alle Passwörter in dieser Dokumentation sind Beispielwerte. In einer produktiven Umgebung müssen sichere Passwörter verwendet werden.

IP-Adressen, Domainnamen und Hostnamen sind frei wählbar und müssen an die eigene Umgebung angepasst werden. Platzhalter sind in spitzen Klammern angegeben, z.B. `<domain-name>` oder `<statische-IP>`.
