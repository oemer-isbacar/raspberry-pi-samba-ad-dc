# Phase 1 – Systemvorbereitung

## Was in dieser Phase passiert

Bevor Samba installiert werden kann, muss das System vorbereitet werden. Dazu gehört ein korrekter Hostname, eine statische IP-Adresse auf dem LAN-Interface und ein aktuelles System.

> Wichtig: Die statische IP darf erst gesetzt werden wenn der Pi physisch am richtigen Switch-Port hängt. Ist der Port nicht korrekt als Access Port des Ziel-VLANs konfiguriert, ist der Pi danach nicht mehr erreichbar.

---

## 1.1 Mit dem Pi verbinden

Den Pi einschalten und die aktuelle IP-Adresse im Router unter den verbundenen Geräten nachschlagen.

```bash
ssh <benutzername>@<IP-Adresse>
```

> Hinweis: Der Benutzername wurde beim Flashen mit dem Raspberry Pi Imager festgelegt. In dieser Anleitung wird `sysadmin` verwendet — der eigene Benutzername muss entsprechend angepasst werden.

> Hinweis: In dieser Phase verbindet man sich noch über die DHCP-Adresse des Pi. Die statische IP wird erst in Schritt 1.4 gesetzt und ist danach nur erreichbar wenn der Pi am richtigen VLAN-Port hängt und das Gateway existiert.

---

## 1.2 System aktualisieren

Das System auf den neuesten Stand bringen. Das dauert je nach Internetverbindung einige Minuten.

```bash
sudo apt update && sudo apt upgrade -y
```

---

## 1.3 Hostname setzen

Den gewünschten Hostnamen für den Domain Controller festlegen. In dieser Anleitung wird `dc01` verwendet.

```bash
sudo hostnamectl set-hostname dc01
```

Dann die `/etc/hosts` Datei anpassen. Auf Pi OS Bookworm verwaltet cloud-init diese Datei — die Änderung muss deshalb in der Template-Datei gemacht werden, sonst wird sie beim nächsten Boot überschrieben.

```bash
sudo nano /etc/cloud/templates/hosts.debian.tmpl
```

Die Zeile mit `127.0.1.1` suchen und durch die eigene statische IP und den vollständigen Hostnamen ersetzen:

```
<statische-IP>   dc01.<domain-name>.local   dc01
```

Beispiel:

```
192.168.20.10   dc01.beispiel.local   dc01
```

> Hinweis: Die `/etc/hosts` direkt zu bearbeiten funktioniert zwar, wird aber bei jedem Neustart von cloud-init überschrieben. Deshalb immer die Template-Datei bearbeiten.

> Hinweis: Nach dem Setzen des Hostnamens erscheint bei sudo-Befehlen die Meldung `sudo: unable to resolve host dc01`. Das ist harmlos und verschwindet nach dem Neustart.

---

## 1.4 Statische IP auf dem LAN-Interface setzen

Auf Pi OS Bookworm übernimmt NetworkManager die Netzwerkkonfiguration, nicht mehr dhcpcd wie bei älteren Versionen. Deshalb funktionieren Anleitungen die `/etc/dhcpcd.conf` bearbeiten hier nicht.

Zuerst den Namen und die UUID der LAN-Verbindung herausfinden:

```bash
nmcli con show
```

Die Ausgabe sieht ungefähr so aus (die genauen Namen und UUIDs sind je nach System unterschiedlich):

```
NAME               UUID                                  TYPE      DEVICE
Wired connection 1 d5d8c075-efe1-3607-8caf-ffadb3991cfa  ethernet  eth0
lo                 3181f89a-771b-4b0d-b37e-f0114dafeb77  loopback  lo
```

Die UUID der LAN-Verbindung notieren. Dann die statische IP setzen:

```bash
sudo nmcli con mod "<Name-der-LAN-Verbindung>" \
  ipv4.addresses <statische-IP>/24 \
  ipv4.gateway <Gateway-IP> \
  ipv4.dns <statische-IP> \
  ipv4.method manual
sudo nmcli con up "<Name-der-LAN-Verbindung>"
```

Beispiel:

```bash
sudo nmcli con mod "Wired connection 1" \
  ipv4.addresses 192.168.20.10/24 \
  ipv4.gateway 192.168.20.1 \
  ipv4.dns 192.168.20.10 \
  ipv4.method manual
sudo nmcli con up "Wired connection 1"
```

> Wichtig: Als DNS-Server wird die eigene IP eingetragen, weil Samba später den DNS-Dienst übernimmt. Das ist korrekt so.

> Wichtig: Falls der Verbindungsname Sonderzeichen wie `!` enthält, schlägt der Befehl mit dem Namen fehl. In diesem Fall die UUID direkt verwenden:
> ```bash
> sudo nmcli con mod <UUID> ipv4.addresses <statische-IP>/24 ...
> ```
> Die UUID stammt aus der Ausgabe von `nmcli con show`.

> Wichtig: Nach dem Aktivieren der Verbindung trennt sich die SSH-Session. Das ist normal — der Pi hat jetzt die statische IP. Neu verbinden mit:
> ```bash
> ssh <benutzername>@<statische-IP>
> ```

---

## 1.5 Zeitzone prüfen

Kerberos, das Authentifizierungsprotokoll von Active Directory, ist sehr zeitkritisch. Pi und Windows-Clients dürfen maximal 5 Minuten voneinander abweichen, sonst schlägt die Anmeldung fehl.

```bash
timedatectl status
```

Die Ausgabe zeigt die aktuelle Zeitzone und NTP-Status. Die relevanten Zeilen:

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
ssh <benutzername>@<statische-IP>
hostname -f
```

Erwartete Ausgabe: `dc01.<domain-name>.local`

---

## Ergebnis

- Hostname ist korrekt gesetzt
- LAN-Interface hat die statische IP
- Zeitzone ist korrekt, NTP ist aktiv
- System ist aktuell

---

Weiter mit [Phase 2 – Samba Installation](02-samba-installation.md)
