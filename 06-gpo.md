# Phase 6 – Gruppenrichtlinien (GPO)

## Ziel

Einfache Gruppenrichtlinien über den Windows-Client mit dem RSAT-Tool (Group Policy Management) erstellen und testen.

---

## 6.1 RSAT auf dem Windows-Client installieren

RSAT (Remote Server Administration Tools) erlaubt die Verwaltung des AD vom Windows-Client aus.

`Einstellungen > Apps > Optionale Features > Feature hinzufügen`

Folgende Features installieren:
- RSAT: Active Directory Domain Services und Lightweight Directory Services Tools
- RSAT: Gruppenrichtlinienverwaltung

---

## 6.2 Gruppenrichtlinienverwaltung öffnen

`Start > Gruppenrichtlinienverwaltung`

Verbindung zur Domain `muellerig.local` wird automatisch hergestellt.

---

## 6.3 Beispiel-GPO: Hintergrundbild für alle Benutzer

Diese GPO setzt ein einheitliches Desktophintergrundbild für alle Domainbenutzer.

1. Rechtsklick auf `muellerig.local > Gruppenrichtlinienobjekt erstellen`
2. Name: `Hintergrundbild-Policy`
3. Rechtsklick auf das neue GPO > Bearbeiten
4. Pfad: `Benutzerkonfiguration > Administrative Vorlagen > Desktop > Desktop`
5. Einstellung: `Desktoptapete`
6. Aktivieren, Pfad zum Bild angeben (muss auf jedem Client lokal vorhanden sein)

---

## 6.4 Beispiel-GPO: Kennwortrichtlinie

Die Standard-Kennwortrichtlinie der Domain wird über `samba-tool` angepasst:

```bash
sudo samba-tool domain passwordsettings set \
  --min-pwd-length=10 \
  --complexity=on \
  --max-pwd-age=90 \
  --min-pwd-age=1 \
  --history-length=5
```

Aktuelle Einstellungen anzeigen:

```bash
sudo samba-tool domain passwordsettings show
```

---

## 6.5 GPO-Anwendung erzwingen (auf dem Client)

```cmd
gpupdate /force
gpresult /r
```

`gpresult /r` zeigt an, welche GPOs auf den aktuellen Benutzer und Computer angewendet werden.

---

## Ergebnis

- RSAT-Tools installiert und mit der Domain verbunden
- Beispiel-GPO für Hintergrundbild erstellt
- Kennwortrichtlinie angepasst
- GPO-Anwendung erfolgreich getestet
