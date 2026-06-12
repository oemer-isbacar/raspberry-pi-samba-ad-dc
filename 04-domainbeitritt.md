# Phase 4 – Windows-Client Domainbeitritt

## Ziel

Einen Windows-10-Client in die Domain `muellerig.local` aufnehmen. Der Client muss im VLAN 20 erreichbar sein und den Pi als DNS-Server nutzen.

---

## 4.1 Voraussetzungen auf dem Windows-Client

Der Windows-Client muss:

- Im gleichen VLAN 20 hängen (192.168.20.x)
- Den Pi als primären DNS-Server eingetragen haben (192.168.20.10)
- Netzwerkkonnektivität zum Pi haben (ping 192.168.20.10)

---

## 4.2 DNS auf dem Windows-Client setzen

`Systemsteuerung > Netzwerkverbindungen > Ethernet > IPv4-Eigenschaften`

```
IP-Adresse:       192.168.20.20
Subnetzmaske:     255.255.255.0
Standardgateway:  192.168.20.1
DNS-Server:       192.168.20.10
```

---

## 4.3 DNS-Auflösung vom Client testen

In der Windows-Eingabeaufforderung (CMD als Administrator):

```cmd
nslookup muellerig.local
nslookup dc01.muellerig.local
```

Beide Abfragen müssen `192.168.20.10` zurückgeben.

---

## 4.4 Domain beitreten

`Systemsteuerung > System > Erweiterte Systemeinstellungen > Computername > Ändern`

- Mitglied von: Domain
- Domain: `muellerig.local`

Es wird nach Zugangsdaten gefragt:

```
Benutzer:   administrator
Passwort:   (das beim Provisionieren gesetzte Passwort)
```

Nach erfolgreichem Beitritt erscheint die Meldung:

```
Willkommen in der Domäne muellerig.local.
```

Neustart des Clients erforderlich.

---

## 4.5 Domainbeitritt überprüfen

Auf dem Pi:

```bash
samba-tool computer list
```

Der Windows-Client sollte in der Liste erscheinen.

---

## 4.6 Domain-Login testen

Am Windows-Client mit einem Domainbenutzer anmelden:

```
muellerig\administrator
```

---

## Ergebnis

- Windows-Client ist Mitglied der Domain `muellerig.local`
- Domain-Login funktioniert
- Client erscheint in der Computerliste auf dem DC
- Weiter mit [Phase 5 – Benutzer & Gruppen](05-benutzer-gruppen.md)
