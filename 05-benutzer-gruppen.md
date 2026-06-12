# Phase 5 – Benutzer und Gruppen anlegen

## Was in dieser Phase passiert

Für das fiktive Unternehmen Müller Ingenieurbüro GmbH werden Benutzer und Gruppen angelegt. Die Struktur orientiert sich an einer typischen kleinen Firma mit verschiedenen Abteilungen.

---

## Organisationsstruktur

| Abteilung | Benutzer |
|---|---|
| Geschäftsführung | m.mueller |
| Buchhaltung | a.schmidt, k.bauer |
| Technik | t.wagner, s.hoffmann, p.richter |
| Empfang | l.klein |
| IT-Administration | administrator |

---

## 5.1 Gruppen anlegen

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
sudo samba-tool user create m.mueller 'Passwort123!' \
  --given-name="Max" --surname="Mueller" \
  --mail-address="m.mueller@muellerig.local"

sudo samba-tool user create a.schmidt 'Passwort123!' \
  --given-name="Anna" --surname="Schmidt" \
  --mail-address="a.schmidt@muellerig.local"

sudo samba-tool user create k.bauer 'Passwort123!' \
  --given-name="Klaus" --surname="Bauer" \
  --mail-address="k.bauer@muellerig.local"

sudo samba-tool user create t.wagner 'Passwort123!' \
  --given-name="Thomas" --surname="Wagner" \
  --mail-address="t.wagner@muellerig.local"

sudo samba-tool user create s.hoffmann 'Passwort123!' \
  --given-name="Sandra" --surname="Hoffmann" \
  --mail-address="s.hoffmann@muellerig.local"

sudo samba-tool user create p.richter 'Passwort123!' \
  --given-name="Peter" --surname="Richter" \
  --mail-address="p.richter@muellerig.local"

sudo samba-tool user create l.klein 'Passwort123!' \
  --given-name="Laura" --surname="Klein" \
  --mail-address="l.klein@muellerig.local"
```

---

## 5.3 Benutzer den Gruppen zuweisen

```bash
sudo samba-tool group addmembers Geschaeftsfuehrung m.mueller
sudo samba-tool group addmembers Buchhaltung a.schmidt,k.bauer
sudo samba-tool group addmembers Technik t.wagner,s.hoffmann,p.richter
sudo samba-tool group addmembers Empfang l.klein
sudo samba-tool group addmembers IT-Admins administrator
```

---

## 5.4 Überprüfung

Alle Benutzer anzeigen:

```bash
sudo samba-tool user list
```

Mitglieder einer Gruppe anzeigen:

```bash
sudo samba-tool group listmembers Technik
```

---

## 5.5 Grafische Verwaltung per RSAT

Falls RSAT auf dem Windows-Client installiert ist, können Benutzer und Gruppen auch grafisch verwaltet werden:

`Win + R` → `dsa.msc`

Dort unter `muellerig.local → Users` sind alle Benutzer und Gruppen sichtbar. Neue Objekte lassen sich per Rechtsklick anlegen.

---

## Ergebnis

- 7 Domainbenutzer angelegt
- 5 Gruppen strukturiert nach Abteilungen
- Benutzer den richtigen Gruppen zugeordnet

---

Weiter mit [Phase 6 – Gruppenrichtlinien](06-gpo.md)
