# Phase 6 – Gruppenrichtlinien (GPO)

## Was in dieser Phase passiert

Gruppenrichtlinien (Group Policy Objects, GPO) ermöglichen es, Einstellungen zentral für alle Benutzer und Computer in der Domain festzulegen. In dieser Phase wird eine Kennwortrichtlinie erstellt und auf die gesamte Domain angewendet.

---

## 6.1 Gruppenrichtlinienverwaltung öffnen

Auf dem Windows-Client (RSAT muss installiert sein):

`Win + R` → `gpmc.msc` → Enter

Im linken Baum: `Gesamtstruktur: muellerig.local` → `Domänen` → `muellerig.local`

---

## 6.2 Neue GPO erstellen

Rechtsklick auf `muellerig.local` → **Gruppenrichtlinienobjekt hier erstellen und verknüpfen**

Name: `Kennwortrichtlinie`

OK klicken.

---

## 6.3 GPO bearbeiten

Rechtsklick auf die neue `Kennwortrichtlinie` → **Bearbeiten**

Im Gruppenrichtlinien-Editor navigieren zu:

`Computerkonfiguration` → `Richtlinien` → `Windows-Einstellungen` → `Sicherheitseinstellungen` → `Kontorichtlinien` → `Kennwortrichtlinien`

Dort folgende Einstellungen setzen:

| Einstellung | Wert |
|---|---|
| Kennwort muss Komplexitätsvoraussetzungen entsprechen | Aktiviert |
| Minimale Kennwortlänge | 10 Zeichen |
| Maximales Kennwortalter | 90 Tage |

Bei "Maximales Kennwortalter" erscheint ein Hinweis dass Windows ein minimales Kennwortalter von 30 Tagen empfiehlt. Mit OK bestätigen.

Editor schließen.

---

## 6.4 GPO anwenden und testen

Auf dem Windows-Client in der CMD als Administrator:

```cmd
gpupdate /force
```

Ausgabe wenn erfolgreich:

```
Die Aktualisierung der Computerrichtlinie wurde erfolgreich abgeschlossen.
Die Aktualisierung der Benutzerrichtlinie wurde erfolgreich abgeschlossen.
```

Prüfen welche GPOs angewendet werden:

```cmd
gpresult /r
```

Unter "Angewendete Gruppenrichtlinienobjekte" sollte `Kennwortrichtlinie` erscheinen und unter "Gruppenrichtlinienanwendung von" muss `dc01.muellerig.local` stehen.

---

## 6.5 Kennwortrichtlinie alternativ per samba-tool setzen

Die Kennwortrichtlinie lässt sich auch direkt auf dem Pi konfigurieren:

```bash
sudo samba-tool domain passwordsettings set \
  --min-pwd-length=10 \
  --complexity=on \
  --max-pwd-age=90
```

Aktuelle Einstellungen anzeigen:

```bash
sudo samba-tool domain passwordsettings show
```

---

## Ergebnis

- GPO `Kennwortrichtlinie` ist erstellt und mit der Domain verknüpft
- Kennwortanforderungen gelten für alle Domainbenutzer
- GPO wird korrekt von `dc01.muellerig.local` ausgeliefert
