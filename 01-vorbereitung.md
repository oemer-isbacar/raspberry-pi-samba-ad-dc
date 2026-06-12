# Phase 1 – Vorbereitung & Systemkonfiguration

## Ziel

Den Raspberry Pi für den Betrieb als Samba AD Domain Controller vorbereiten. Dazu gehört eine statische IP-Adresse, ein korrekter Hostname und ein aktuelles System.

---

## 1.1 Statische IP-Adresse setzen

Der Pi bekommt die feste IP `192.168.20.10` im VLAN 20.

Datei bearbeiten:

```bash
sudo nano /etc/dhcpcd.conf
```

Folgendes ans Ende anfügen:

```
interface eth0
static ip_address=192.168.20.10/24
static routers=192.168.20.1
static domain_name_servers=192.168.20.10
```

> Hinweis: Als DNS-Server wird später der Pi selbst eingetragen, weil Samba den DNS-Dienst übernimmt.

---

## 1.2 Hostname setzen

```bash
sudo hostnamectl set-hostname dc01
```

Dann `/etc/hosts` anpassen:

```bash
sudo nano /etc/hosts
```

Eintrag ergänzen:

```
192.168.20.10   dc01.muellerig.local   dc01
```

---

## 1.3 System aktualisieren

```bash
sudo apt update && sudo apt upgrade -y
```

---

## 1.4 Zeitzone setzen

AD-Kerberos ist zeitkritisch. Clients und Server müssen dieselbe Uhrzeit haben (max. 5 Minuten Abweichung).

```bash
sudo timedatectl set-timezone Europe/Berlin
timedatectl status
```

---

## 1.5 NTP prüfen

```bash
sudo apt install ntp -y
sudo systemctl enable ntp
sudo systemctl start ntp
```

---

## 1.6 Neustart

```bash
sudo reboot
```

Nach dem Neustart prüfen:

```bash
hostname -f
# Erwartete Ausgabe: dc01.muellerig.local

ip a
# Erwartete Ausgabe: 192.168.20.10/24 auf eth0
```

---

## Ergebnis

- Pi hat statische IP `192.168.20.10`
- Hostname ist `dc01.muellerig.local`
- System ist aktuell
- Zeitzone ist korrekt gesetzt
- Weiter mit [Phase 2 – Samba Installation](02-samba-installation.md)
