# Samba 4 Active Directory Domain Controller auf dem Raspberry Pi 4

Dieses Projekt zeigt wie man einen vollwertigen Active Directory Domain Controller auf einem Raspberry Pi 4 betreibt. Als Software kommt Samba 4 zum Einsatz, das die AD-Funktionalität von Windows Server nachbildet. Windows-Clients können der Domain beitreten, Benutzer werden zentral verwaltet und Gruppenrichtlinien werden domainweit verteilt.

Das Projekt habe ich als Lernprojekt im Rahmen meiner FISI-Umschulung aufgebaut. Die Dokumentation ist so geschrieben, dass sie auch ohne Vorkenntnisse nachvollziehbar ist.

---

## Was am Ende funktioniert

- Samba 4 läuft als AD Domain Controller
- Die Domain `muellerig.local` ist eingerichtet
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

In diesem Projekt läuft der Pi im Servernetz hinter einer OPNsense-Firewall. Der Aufbau lässt sich aber auch zuhause ohne Firewall nachbauen, solange Pi und Windows-Client im gleichen Netz hängen.

```
Router/Firewall (Gateway)
        |
   Raspberry Pi 4
   IP: 192.168.20.10
   dc01.muellerig.local
        |
   Windows-Client
   IP: 192.168.20.x
```

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
| Samba 4.22 | Active Directory Domain Controller |
| MIT Kerberos | Authentifizierung |
| NetworkManager | Netzwerkkonfiguration |

---

## Hinweise

Dieses Projekt dient Lern- und Dokumentationszwecken. Die verwendeten Passwörter (`Passwort123!`) sind Beispielwerte und sollten in produktiven Umgebungen durch sichere Passwörter ersetzt werden.
