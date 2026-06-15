# Phase 5 – Benutzer und Gruppen anlegen

## Was in dieser Phase passiert

Benutzer und Gruppen werden für die Domain angelegt. Die Struktur kann beliebig an die eigene Umgebung angepasst werden.

---

## 5.1 Gruppen anlegen

```bash
sudo samba-tool group add <Gruppenname>
```

Beispiele:

```bash
sudo samba-tool group add Geschaeftsfuehrung
sudo samba-tool group add Buchhaltung
sudo samba-tool group add Technik
sudo samba-tool group add Empfang
sudo samba-tool group add IT-Admins
```

---

## 5.2 Benutzer anlegen

```bash
sudo samba-tool user create <benutzername> '<passwort>' \
  --given-name="<Vorname>" --surname="<Nachname>" \
  --mail-address="<benutzername>@<domain-name>.local"
```

Beispiel:

```bash
sudo samba-tool user create m.mustermann 'Passwort123!' \
  --given-name="Max" --surname="Mustermann" \
  --mail-address="m.mustermann@beispiel.local"
```

---

## 5.3 Benutzer den Gruppen zuweisen

```bash
sudo samba-tool group addmembers <Gruppenname> <benutzername>
```

Mehrere Benutzer auf einmal:

```bash
sudo samba-tool group addmembers <Gruppenname> benutzer1,benutzer2,benutzer3
```

---

## 5.4 Überprüfung

Alle Benutzer anzeigen:

```bash
sudo samba-tool user list
```

Mitglieder einer Gruppe anzeigen:

```bash
sudo samba-tool group listmembers <Gruppenname>
```

---

## 5.5 Grafische Verwaltung per RSAT

Falls RSAT auf dem Windows-Client installiert ist, können Benutzer und Gruppen auch grafisch verwaltet werden:

`Win + R` → `dsa.msc`

Dort unter der eigenen Domain sind alle Benutzer und Gruppen sichtbar. Neue Objekte lassen sich per Rechtsklick anlegen.

---

## Ergebnis

- Domainbenutzer sind angelegt
- Gruppen sind strukturiert
- Benutzer den richtigen Gruppen zugeordnet

---

Weiter mit [Phase 6 – Gruppenrichtlinien](06-gpo.md)
