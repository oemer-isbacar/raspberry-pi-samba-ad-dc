# Phase 5 – Benutzer & Gruppen anlegen

## Ziel

Realistische Benutzer und Gruppen für das fiktive Unternehmen Müller Ingenieurbüro GmbH anlegen. Das spiegelt eine typische kleine Unternehmensstruktur wider.

---

## 5.1 Organisationsstruktur

Das Unternehmen hat 10 Mitarbeiter in zwei Abteilungen:

| Abteilung | Mitarbeiter |
|---|---|
| Geschäftsführung | m.mueller |
| Buchhaltung | a.schmidt, k.bauer |
| Technik | t.wagner, s.hoffmann, p.richter |
| Empfang | l.klein |
| IT (Admin) | admin |

---

## 5.2 Gruppen anlegen

```bash
sudo samba-tool group add Geschaeftsfuehrung
sudo samba-tool group add Buchhaltung
sudo samba-tool group add Technik
sudo samba-tool group add Empfang
sudo samba-tool group add IT-Admins
```

---

## 5.3 Benutzer anlegen

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

## 5.4 Benutzer zu Gruppen hinzufügen

```bash
sudo samba-tool group addmembers Geschaeftsfuehrung m.mueller
sudo samba-tool group addmembers Buchhaltung a.schmidt,k.bauer
sudo samba-tool group addmembers Technik t.wagner,s.hoffmann,p.richter
sudo samba-tool group addmembers Empfang l.klein
sudo samba-tool group addmembers IT-Admins administrator
```

---

## 5.5 Überprüfung

```bash
# Alle Benutzer anzeigen
samba-tool user list

# Mitglieder einer Gruppe anzeigen
samba-tool group listmembers Technik
```

---

## Ergebnis

- 7 Domainbenutzer angelegt
- 5 Gruppen strukturiert nach Abteilungen
- Benutzer den richtigen Gruppen zugeordnet
- Weiter mit [Phase 6 – Gruppenrichtlinien](06-gpo.md)
