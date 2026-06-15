# Phase 4 – Windows-Client in die Domain aufnehmen

## Was in dieser Phase passiert

Ein Windows-Client tritt der Domain bei. Danach kann man sich am Client mit einem Domainbenutzer anmelden.

---

## 4.1 Voraussetzungen

- Der Windows-Client muss im gleichen Netz wie der Pi sein
- Pi und Client müssen sich gegenseitig anpingen können
- Der Client braucht den Pi als DNS-Server

---

## 4.2 DNS auf dem Windows-Client setzen

Der Windows-Client muss den Pi als DNS-Server nutzen, damit er die Domain auflösen kann. Ohne das schlägt der Domainbeitritt fehl.

`Win + R` → `ncpa.cpl` → Enter

Auf die aktive Netzwerkverbindung rechtsklicken → Eigenschaften → Internetprotokoll Version 4 (TCP/IPv4) → Eigenschaften

Dort "Folgenden DNS-Server verwenden" auswählen:

```
Bevorzugter DNS-Server: <statische-IP-des-Pi>
```

OK, OK.

> Hinweis: Falls nslookup im nächsten Schritt trotzdem eine falsche Adresse liefert, liegt das meist daran dass Windows die IPv6-Adresse des Routers als DNS nutzt. In diesem Fall IPv6 in den Netzwerkeinstellungen temporär deaktivieren: Den Haken bei "Internetprotokoll Version 6 (TCP/IPv6)" entfernen.

---

## 4.3 DNS-Auflösung testen

In der Eingabeaufforderung (CMD):

```cmd
nslookup <domain-name>.local
```

Erwartete Ausgabe:

```
Server:  dc01.<domain-name>.local
Address:  <statische-IP-des-Pi>

Name:    <domain-name>.local
Address:  <statische-IP-des-Pi>
```

Erst wenn diese Abfrage funktioniert, den Domainbeitritt starten.

---

## 4.4 Domain beitreten

`Win + R` → `sysdm.cpl` → Enter

Reiter "Computername" → "Ändern" → bei "Mitglied von" auf **Domäne** wechseln:

```
<domain-name>.local
```

OK klicken. Es erscheint ein Anmeldefenster. Dort die Domain-Administrator-Zugangsdaten eingeben:

```
Benutzer:   administrator
Passwort:   <administrator-passwort>
```

Bei Erfolg erscheint:

```
Willkommen in der Domäne <domain-name>.local.
```

Danach ist ein Neustart erforderlich.

---

## 4.5 Domain-Login testen

Nach dem Neustart am Anmeldebildschirm auf "Anderer Benutzer" klicken:

```
<domain-name>\administrator
```

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

- Windows-Client ist Mitglied der Domain
- Domain-Login funktioniert
- Client erscheint in der Computerliste auf dem DC

---

Weiter mit [Phase 5 – Benutzer und Gruppen](05-benutzer-gruppen.md)
