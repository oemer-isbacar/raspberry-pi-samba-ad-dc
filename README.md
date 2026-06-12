# Samba 4 Active Directory Domain Controller auf Raspberry Pi 4

Dieses Projekt dokumentiert die Einrichtung eines vollwertigen Active Directory Domain Controllers auf Basis von Samba 4, betrieben auf einem Raspberry Pi 4 (4 GB RAM) mit Raspberry Pi OS Lite.

Der Pi ist im Servernetz (VLAN 20, 192.168.20.0/24) hinter einer OPNsense-Firewall eingebunden. Windows-Clients können der Domain beitreten, Benutzer und Gruppen werden zentral verwaltet.

---

## Ziel

- Samba 4 als AD DC konfigurieren
- DNS-Integration für die Domain `muellerig.local`
- Windows-Client in die Domain aufnehmen
- Benutzer und Gruppenrichtlinien verwalten

---

## Hardware

| Komponente | Modell |
|---|---|
| Domain Controller | Raspberry Pi 4 (4 GB RAM, 32 GB SD) |
| Betriebssystem | Raspberry Pi OS Lite (64-bit, Debian 12) |
| Netzwerk | VLAN 20 – Servernetz, 192.168.20.0/24 |
| Firewall | Protecli Vault FW4B (OPNsense) |
| Switch | Netgear GS308E (managed, 802.1Q VLAN) |
| Test-Client | Lenovo ThinkStation (Windows 10) |

---

## Netzwerkplan

```
OPNsense (192.168.20.1)
        |
   [VLAN 20 – Server]
        |
   Raspberry Pi 4
   192.168.20.10
   dc01.muellerig.local
```

---

## Projektphasen

| Phase | Inhalt | Status |
|---|---|---|
| 1 | Vorbereitung & Systemkonfiguration | Geplant |
| 2 | Samba 4 Installation & AD-Provisionierung | Geplant |
| 3 | DNS-Konfiguration | Geplant |
| 4 | Windows-Client Domainbeitritt | Geplant |
| 5 | Benutzer & Gruppen anlegen | Geplant |
| 6 | Gruppenrichtlinien (GPO) | Geplant |
| 7 | Tests & Dokumentation | Geplant |

---

## Dokumentation

Die ausführliche Schritt-für-Schritt-Dokumentation liegt im Ordner [`docs/`](docs/):

- [01-vorbereitung.md](docs/01-vorbereitung.md) – Systemvorbereitung, IP, Hostname
- [02-samba-installation.md](docs/02-samba-installation.md) – Installation und AD-Provisionierung
- [03-dns.md](docs/03-dns.md) – DNS-Konfiguration und Überprüfung
- [04-domainbeitritt.md](docs/04-domainbeitritt.md) – Windows-Client einbinden
- [05-benutzer-gruppen.md](docs/05-benutzer-gruppen.md) – Benutzerverwaltung
- [06-gpo.md](docs/06-gpo.md) – Gruppenrichtlinien

---

## Verwendete Software

| Software | Version | Zweck |
|---|---|---|
| Raspberry Pi OS Lite | Debian 12 (Bookworm) | Basisbetriebssystem |
| Samba | 4.17+ | AD Domain Controller |
| Kerberos | MIT Kerberos | Authentifizierung |
| BIND9 / Samba-intern | – | DNS |

---

## Lizenz

Dieses Projekt dient Lern- und Dokumentationszwecken im Rahmen einer FISI-Umschulung (IHK).
