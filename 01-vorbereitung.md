# Phase 1 – Systemvorbereitung

## Was in dieser Phase passiert

Bevor Samba installiert werden kann, muss das System vorbereitet werden. Dazu gehört ein korrekter Hostname, eine statische IP-Adresse auf dem LAN-Interface und ein aktuelles System. Das WLAN-Interface bleibt für die Erstkonfiguration aktiv, damit der Pi auch ohne angestecktes LAN-Kabel erreichbar ist.

---

## 1.1 Mit dem Pi verbinden

Der Pi muss eingeschaltet und im Netzwerk erreichbar sein. Die aktuelle IP-Adresse findet man im Router unter den verbundenen Geräten.

```bash
ssh sysadmin@<IP-Adresse>
```

---

## 1.2 System aktualisieren

Als erstes das System auf den neuesten Stand bringen. Das dauert je nach Internetverbindung einige Minuten.

```bash
sudo apt update && sudo apt upgrade -y
```

---

## 1.3 Hostname setzen

Der Pi soll später als `dc01.muellerig.local` erreichbar sein. Dazu zuerst den Hostnamen setzen:

```bash
sudo hostnamectl set-hostname dc01
```

Dann die `/etc/hosts` Datei anpassen. Auf Pi OS Bookworm verwaltet cloud-init diese Datei, deshalb muss die Änderung in der Template-Datei gemacht werden, sonst wird sie beim nächsten Boot überschrieben.

```bash
sudo nano /etc/cloud/templates/hosts.debian.tmpl
```

Die Zeile mit `127.0.1.1` suchen und ersetzen durch:

```
192.168.20.10   dc01.muellerig.local   dc01
```

> Hinweis: Die `/etc/hosts` direkt zu bearbeiten funktioniert zwar, wird aber bei jedem Neustart von cloud-init überschrieben. Deshalb immer die Template-Datei bearbeiten.

---

## 1.4 Statische IP auf dem LAN-Interface setzen

Auf Pi OS Bookworm übernimmt NetworkManager die Netzwerkkonfiguration, nicht mehr dhcpcd wie bei älteren Versionen. Deshalb funktionieren Anleitungen die `/etc/dhcpcd.conf` bearbeiten hier nicht.

Zuerst den Namen der LAN-Verbindung herausfinden:

```bash
nmcli con show
```

Die Ausgabe sieht ungefähr so aus:

```
NAME                     UUID                                  TYPE      DEVICE
netplan-wlan0-FRITZ!Box  25286fe5-...                          wifi      wlan0
lo                       d1af314d-...                          loopback  lo
netplan-eth0             75a1216e-...                          ethernet  --
```

Die LAN-Verbindung heißt `netplan-eth0`. Die UUID aus der Ausgabe notieren.

Statische IP setzen:

```bash
sudo nmcli con mod "netplan-eth0" \
  ipv4.addresses 192.168.20.10/24 \
  ipv4.gateway 192.168.20.1 \
  ipv4.dns 192.168.20.10 \
  ipv4.method manual
```

> Wichtig: Als DNS-Server wird die eigene IP eingetragen, weil Samba später den DNS-Dienst übernimmt. Das ist korrekt so.

> Wichtig: Falls der Verbindungsname Sonderzeichen wie `!` enthält, schlägt der Befehl mit dem Namen fehl. In diesem Fall die UUID direkt verwenden:
> ```bash
> sudo nmcli con mod <UUID> ipv4.addresses 192.168.20.10/24 ...
> ```

---

## 1.5 Zeitzone prüfen

Kerberos, das Authentifizierungsprotokoll von Active Directory, ist sehr zeitkritisch. Pi und Windows-Clients dürfen maximal 5 Minuten voneinander abweichen, sonst schlägt die Anmeldung fehl. Deshalb die Zeitzone kontrollieren:

```bash
timedatectl status
```

Erwartete Ausgabe:

```
Time zone: Europe/Berlin (CEST, +0200)
NTP service: active
```

Falls die Zeitzone falsch ist:

```bash
sudo timedatectl set-timezone Europe/Berlin
```

> Hinweis: systemd-resolved ist auf Pi OS Bookworm nicht installiert und muss nicht deaktiviert werden. Anleitungen die `systemctl disable systemd-resolved` empfehlen, können diesen Schritt überspringen.

---

## 1.6 Neustart

```bash
sudo reboot
```

Nach dem Neustart neu verbinden und prüfen:

```bash
ssh sysadmin@<WLAN-IP>
hostname -f
```

Erwartete Ausgabe: `dc01.muellerig.local`

---

## Ergebnis

- Hostname ist `dc01.muellerig.local`
- LAN-Interface hat die statische IP `192.168.20.10`
- Zeitzone ist `Europe/Berlin`, NTP ist aktiv
- System ist aktuell
