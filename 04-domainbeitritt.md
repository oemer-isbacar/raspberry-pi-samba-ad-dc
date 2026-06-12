# Phase 4 – Windows-Client in die Domain aufnehmen

## Was in dieser Phase passiert

Ein Windows-Client tritt der Domain `muellerig.local` bei. Danach kann man sich am Client mit einem Domainbenutzer anmelden.

---

## 4.1 Voraussetzungen

- Der Windows-Client muss im gleichen Netz wie der Pi sein
- Pi und Client müssen sich gegenseitig anpingen können
- Der Client braucht den Pi als DNS-Server

---

## 4.2 DNS auf dem Windows-Client setzen

Der Windows-Client muss den Pi als DNS-Server nutzen, damit er die Domain `muellerig.local` auflösen kann. Ohne das schlägt der Domainbeitritt fehl.

`Win + R` → `ncpa.cpl` → Enter

Auf die aktive Netzwerkverbindung (WLAN oder LAN) rechtsklicken → Eigenschaften → Internetprotokoll Version 4 (TCP/IPv4) → Eigenschaften

Dort "Folgenden DNS-Server verwenden" auswählen:

```
Bevorzugter DNS-Server: 192.168.20.10
```

OK, OK.

> Hinweis: Falls der Client per IPv6 verbunden ist und nslookup trotzdem eine falsche Adresse liefert, IPv6 in den Netzwerkeinstellungen temporär deaktivieren. Den Haken bei "Internetprotokoll Version 6 (TCP/IPv6)" entfernen.

---

## 4.3 DNS-Auflösung testen

In der Eingabeaufforderung (CMD):

```cmd
nslookup muellerig.local
```

Erwartete Ausgabe:

```
Server:  dc01.muellerig.local
Address:  192.168.20.10

Name:    muellerig.local
Address:  192.168.20.10
```

Erst wenn diese Abfrage funktioniert, den Domainbeitritt starten.

---

## 4.4 Domain beitreten

`Win + R` → `sysdm.cpl` → Enter

Reiter "Computername" → "Ändern" → bei "Mitglied von" auf **Domäne** wechseln:

```
muellerig.local
```

OK klicken. Es erscheint ein Anmeldefenster. Dort die Domain-Administrator-Zugangsdaten eingeben:

```
Benutzer:   administrator
Passwort:   Passwort123!
```

Bei Erfolg erscheint:

```
Willkommen in der Domäne muellerig.local.
```

Danach ist ein Neustart erforderlich.

---

## 4.5 Domain-Login testen

Nach dem Neustart am Anmeldebildschirm auf "Anderer Benutzer" klicken und einen Domainbenutzer eingeben:

```
muellerig\administrator
```

oder einen der angelegten Benutzer aus Phase 5.

---

## 4.6 Domainbeitritt auf dem Pi prüfen

```bash
sudo samba-tool computer list
```

Der Windows-Client sollte in der Liste erscheinen.

---

## 4.7 RSAT installieren (optional aber empfohlen)

Mit den Remote Server Administration Tools lässt sich die Domain grafisch verwalten — Benutzer, Gruppen, Gruppenrichtlinien, alles per Mausklick wie bei Windows Server.

`Einstellungen` → `System` → `Optionale Features` → `Feature hinzufügen`

Suche nach `active` und installiere:
- RSAT: Tools für Active Directory Domain Services und Lightweight Directory Services

Suche nach `gruppen` und installiere:
- RSAT: Gruppenrichtlinienverwaltung

Nach der Installation:

- `dsa.msc` → Active Directory Benutzer und Computer
- `gpmc.msc` → Gruppenrichtlinienverwaltung

---

## 4.8 Client wieder aus der Domain entfernen

Um den Client wieder aus der Domain zu nehmen:

`sysdm.cpl` → Computername → Ändern → bei "Mitglied von" auf **Arbeitsgruppe** → `WORKGROUP`

Zugangsdaten eingeben, Neustart. Danach DNS wieder auf automatisch stellen.

---

## Ergebnis

- Windows-Client ist Mitglied der Domain `muellerig.local`
- Domain-Login funktioniert
- Client erscheint in der Computerliste auf dem DC

---

Weiter mit [Phase 5 – Benutzer und Gruppen](05-benutzer-gruppen.md)
