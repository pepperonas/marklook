# MarkLook – Claude Code CLI Prompt

## Rolle

Du bist Senior macOS Software Architect und Senior Swift Developer mit Schwerpunkt auf:

- Swift
- SwiftUI
- AppKit
- Quick Look
- Quick Look Preview Extensions
- macOS Extensions
- Uniform Type Identifiers (UTType)
- Markdown / CommonMark / GitHub Flavored Markdown
- WebKit
- macOS Sandboxing
- Code Signing
- Performance
- native Apple UX

Du entwickelst eine neue native macOS-Anwendung namens:

**MarkLook**

Repository / Projektname:

`marklook`

Bundle Identifier:

`io.celox.marklook`

Initiale Version:

`0.0.1`

---

# Ziel

Entwickle eine native macOS-App, die Markdown-Dateien insbesondere im Finder über Quick Look korrekt formatiert darstellt.

Das zentrale Benutzererlebnis soll sein:

1. Benutzer markiert eine `.md`-Datei im Finder.
2. Benutzer drückt die Leertaste.
3. Statt Markdown-Rohtext erscheint eine hochwertig gerenderte Markdown-Vorschau.
4. Die Darstellung fügt sich visuell möglichst natürlich in macOS ein.

Beispiel:

Aus:

```markdown
# Architektur

Die Anwendung verwendet **Swift** und unterstützt:

- Markdown
- Tabellen
- Codeblöcke
- Task Lists

```swift
struct Example {
    let value: String
}
```
```

soll eine tatsächlich formatierte Quick-Look-Vorschau werden.

---

# WICHTIG: Erst recherchieren

Bevor du Code schreibst:

1. Ermittle die aktuell von Apple vorgesehene Architektur für Quick-Look-Preview-Extensions unter der aktuell installierten macOS- und Xcode-Version.

2. Prüfe insbesondere:
   - Quick Look Preview Extensions
   - `QLPreviewProvider`
   - `QLPreviewReply`
   - UTType / UniformTypeIdentifiers
   - Extension Points
   - App Sandbox
   - Code Signing
   - Installation/Aktivierung von Extensions
   - Verhalten für `.md` und `.markdown`
   - Konflikte mit der eingebauten macOS-Textvorschau
   - ob HTML als Preview-Repräsentation sinnvoll und unterstützt ist
   - welche APIs aktuell und welche deprecated sind

3. Verwende keine alten QuickLook-Generator-Ansätze nur deshalb, weil sie in älteren Tutorials häufig vorkommen.

4. Prüfe die lokal installierten SDKs, Xcode-Version und verfügbaren APIs.

5. Wenn nötig, recherchiere Apples aktuelle Dokumentation.

Erstelle anschließend einen kurzen technischen Plan.

Wenn es bei einer fundamentalen Architekturentscheidung mehrere ernsthaft sinnvolle Varianten gibt, erkläre sie kurz und frage mich, bevor du dich festlegst.

Bei normalen Implementierungsdetails darfst du selbstständig entscheiden.

---

# Grundprinzip

MarkLook soll eine kleine, schnelle und vollständig native macOS-Anwendung werden.

Kein:

- Electron
- Node.js Runtime
- lokaler Webserver
- unnötiger Hintergrunddienst
- Cloud-Service
- Telemetrie
- Account
- Tracking

Bevorzuge:

**Swift + SwiftUI + AppKit + native macOS APIs.**

Eine WebView darf innerhalb der Preview verwendet werden, falls dies technisch die beste Möglichkeit zur hochwertigen Markdown-/HTML-Darstellung ist.

Die eigentliche Anwendung soll trotzdem vollständig nativ bleiben.

---

# Projektarchitektur

Entwirf eine saubere Architektur von Grund auf.

Mindestens berücksichtigen:

```text
MarkLook.app
    │
    ├── Haupt-App
    │   ├── Einstellungen
    │   ├── Status der Extension
    │   ├── Beispiel / Preview
    │   └── About
    │
    ├── Quick Look Preview Extension
    │   └── Markdown Preview Provider
    │
    └── Shared
        ├── Markdown Renderer
        ├── Theme
        ├── CSS
        ├── UTType Handling
        └── Utilities
```

Vermeide unnötige Abstraktionen und Overengineering.

---

# Markdown-Unterstützung

Unterstütze mindestens:

- H1–H6
- Paragraphen
- Bold
- Italic
- Bold + Italic
- Strikethrough
- Links
- Inline Code
- fenced Code Blocks
- Blockquotes
- geordnete Listen
- ungeordnete Listen
- verschachtelte Listen
- horizontale Linien
- Tabellen
- Task Lists
- Bilder
- Escaping
- Unicode
- Emojis

Ziel ist möglichst gute Unterstützung für:

**CommonMark**

und, wo sinnvoll:

**GitHub Flavored Markdown.**

---

# Codeblöcke

Codeblöcke sollen hochwertig dargestellt werden.

Berücksichtige:

- Monospace-Systemschrift
- Language Identifier
- Syntax Highlighting, sofern ohne unverhältnismäßige Abhängigkeiten möglich
- horizontales Scrollen bei langen Zeilen
- Copy-Funktion nur dann, wenn sie innerhalb von Quick Look sinnvoll umsetzbar ist

Unterstütze typische Sprachen wie:

- Swift
- Rust
- Java
- Kotlin
- JavaScript
- TypeScript
- Python
- Shell/Bash
- JSON
- YAML
- XML
- HTML
- CSS
- SQL
- Markdown

---

# Design

Die Vorschau soll sich wie eine hochwertige native macOS-Komponente anfühlen.

Kein GitHub-Klon.

Kein auffälliges eigenes Branding innerhalb der Dokumentvorschau.

Orientiere dich an Apples aktueller macOS Designsprache.

Berücksichtige:

- Light Mode
- Dark Mode
- Systemfarben
- System Typography
- SF Pro
- SF Mono
- sinnvolle maximale Textbreite
- gute Lesbarkeit
- klare Hierarchie
- großzügige, aber nicht übertriebene Abstände
- native Linkdarstellung
- hochwertige Tabellen
- dezente Blockquotes
- hochwertige Codeblöcke
- Retina
- unterschiedliche Fenstergrößen

Die Vorschau soll ungefähr wirken wie:

> „So hätte Apple eine native Markdown-Vorschau implementiert.“

---

# Dark / Light Mode

Die Darstellung muss automatisch auf das aktuelle macOS Appearance reagieren.

Keine hart codierten Farben, wenn Systemwerte bzw. adaptive Werte sinnvoll verwendet werden können.

Auch gerendertes HTML/CSS muss Light/Dark Mode korrekt unterstützen.

---

# Bilder

Markdown-Bilder sollen unterstützt werden.

Beachte insbesondere relative Pfade:

```markdown
![Architecture](./images/architecture.png)
```

Wenn technisch und sicher möglich, sollen lokale relative Ressourcen relativ zum Markdown-Dokument aufgelöst werden.

Verhindere dabei unerwünschten Zugriff außerhalb sinnvoller lokaler Ressourcen.

---

# Sicherheit

Markdown-Dateien sind nicht vertrauenswürdig.

Daher:

- kein beliebiges JavaScript aus Markdown ausführen
- HTML sanitizen, falls Raw HTML unterstützt wird
- keine Remote-Skripte
- keine automatische Codeausführung
- keine Shell-Aufrufe aufgrund von Dokumentinhalt
- sichere URL-Behandlung
- sichere lokale Ressourcenauflösung
- Path Traversal berücksichtigen
- WebView möglichst restriktiv konfigurieren

Remote-Bilder sollten nicht ungefragt Tracking ermöglichen.

Entscheide, ob sie standardmäßig blockiert werden sollten.

---

# Performance

Quick Look muss schnell sein.

Eine normale Markdown-Datei sollte subjektiv praktisch sofort erscheinen.

Berücksichtige:

- minimale Startup-Zeit
- keine unnötigen Prozesse
- effizientes Parsing
- effizientes HTML Rendering
- große Markdown-Dateien
- große Codeblöcke
- große Tabellen
- Bilder

Teste mindestens Dateien mit:

- 1 KB
- 100 KB
- 1 MB
- 5 MB

Die Preview darf bei ungewöhnlich großen Dateien kontrolliert degradieren, statt Finder/Quick Look zu blockieren.

---

# Haupt-App

MarkLook soll zusätzlich eine kleine native Hauptanwendung besitzen.

Sie soll nicht nur ein leeres Container-Fenster für die Extension sein.

Erstelle eine reduzierte Oberfläche mit:

```text
MARKLOOK

Markdown previews for macOS

[ Extension Status ]

Quick Look Preview
✓ Installed / Enabled
```

Darunter beispielsweise:

## Preview

Eine kleine integrierte Beispiel-Markdown-Datei mit gerenderter Vorschau.

Außerdem:

- Settings
- About

---

# Settings

Nur Einstellungen anbieten, die tatsächlich sinnvoll sind.

Mögliche Optionen:

### Appearance

- System
- Light
- Dark

### Text Size

- Small
- Standard
- Large

### Content Width

- Compact
- Standard
- Wide

### Remote Images

- Block
- Allow

### Syntax Highlighting

- On
- Off

Falls bestimmte Optionen aufgrund der Isolation der Quick-Look-Extension technisch problematisch sind, untersuche zuerst eine saubere Lösung über App Groups/UserDefaults.

---

# Onboarding

Beim ersten Start soll MarkLook kurz erklären:

1. Was die App macht.
2. Dass Markdown über Finder → Quick Look angezeigt wird.
3. Wie eine eventuell notwendige Extension aktiviert wird.

Wenn macOS eine manuelle Aktivierung in den Systemeinstellungen verlangt, zeige präzise und zur installierten macOS-Version passende Hinweise.

Keine erfundenen Einstellungswege.

---

# UTTypes

Unterstütze mindestens:

- `.md`
- `.markdown`

Prüfe die korrekten UTTypes der aktuellen macOS-Version.

Registriere keine unnötigen Dateitypen.

---

# Fehlerbehandlung

Wenn Markdown nicht gerendert werden kann:

Keine leere Preview und kein Crash.

Stattdessen eine saubere Fallback-Darstellung.

Logging nur für technisch relevante Informationen.

Keine sensiblen Dokumentinhalte loggen.

---

# Tests

Implementiere sinnvolle Tests für:

- Markdown Parsing
- HTML Escaping
- Sanitization
- Links
- Bilder
- relative Pfade
- Path Traversal
- Tabellen
- Task Lists
- Codeblöcke
- Unicode
- Dark/Light Rendering soweit automatisiert sinnvoll
- große Dateien
- beschädigte Dateien

Erstelle außerdem Test-Fixtures unter:

`Tests/Fixtures/`

z. B.:

```text
basic.md
gfm.md
code.md
tables.md
images.md
unicode.md
large.md
malicious.md
```

---

# Beispiel-Testdatei

Erstelle eine `MARKDOWN_TEST.md`, mit der möglichst viele unterstützte Markdown-Funktionen visuell getestet werden können.

Sie soll als manueller Integrationstest für Quick Look dienen.

---

# Developer Experience

Das Projekt muss direkt in Xcode geöffnet und gebaut werden können.

Erstelle außerdem:

- `README.md`
- `CHANGELOG.md`
- `LICENSE`

README soll enthalten:

- Screenshot-Platzhalter
- Funktionsumfang
- Installation
- Quick-Look-Aktivierung
- Build from Source
- Architekturübersicht
- unterstützte Markdown-Funktionen
- Security-Konzept
- bekannte Einschränkungen

---

# Repository Hygiene

Erstelle eine passende `.gitignore`.

Keine:

- DerivedData
- Build-Artefakte
- lokale User Settings
- Secrets
- Zertifikate

committen.

---

# Versionierung

Starte mit:

`0.0.1`

Die Version ist ausdrücklich eine frühe Development-Version.

---

# Qualitätsanforderungen

Der Code soll:

- idiomatisches modernes Swift verwenden
- verständlich strukturiert sein
- möglichst wenige externe Dependencies besitzen
- keine unnötigen Patterns einführen
- testbar sein
- dokumentiert sein, wo Architekturentscheidungen nicht offensichtlich sind
- Swift Concurrency korrekt einsetzen, wo sinnvoll

Warnings sind zu vermeiden.

Keine TODO-Platzhalter für zentrale Funktionen.

---

# Besonders wichtig: tatsächlicher Quick-Look-Test

Die Aufgabe ist nicht abgeschlossen, nur weil die App kompiliert.

Teste den realen Workflow soweit lokal möglich:

**Finder → Markdown-Datei auswählen → Space → MarkLook Preview**

Prüfe außerdem über geeignete macOS-Werkzeuge, ob die Extension:

- gebaut wurde
- eingebettet ist
- von macOS registriert wurde
- den korrekten Content Type beansprucht

Falls die Extension nicht automatisch verwendet wird:

Analysiere die Ursache systematisch.

Prüfe beispielsweise:

- Extension Registration
- Info.plist
- NSExtension
- UTTypes
- PlugInKit
- Quick Look Cache
- konkurrierende Preview Extensions
- macOS-eigene Handler

Führe keine destruktiven Systemänderungen ohne Rückfrage aus.

---

# Vorgehen

Arbeite in diesen Phasen:

## Phase 1 – Systemanalyse

Prüfe:

- macOS-Version
- Xcode-Version
- Swift-Version
- relevante SDKs
- aktuelle Quick-Look-APIs

Berichte kurz über das Ergebnis.

## Phase 2 – Architektur

Entwirf die Architektur.

Zeige:

- Targets
- Module
- wichtigste Typen
- Rendering Pipeline
- Quick-Look-Integration
- Sicherheitsmodell
- Dependency-Auswahl

Begründe wesentliche Entscheidungen.

## Phase 3 – Implementierung

Implementiere das vollständige Projekt.

## Phase 4 – Tests

Führe:

- Build
- Unit Tests
- relevante Integration Tests
- Extension Validation

durch.

Behebe gefundene Probleme.

## Phase 5 – Realer Quick-Look-Test

Teste soweit automatisierbar die Registrierung und Funktionsfähigkeit der Extension.

Gib mir anschließend konkrete Schritte für den manuellen Test im Finder.

## Phase 6 – Review

Überprüfe abschließend selbst:

- Funktionalität
- Architektur
- Security
- Performance
- UX
- macOS-Konformität
- Fehlerbehandlung
- Testabdeckung

Behebe erkannte Probleme direkt.

---

# Definition of Done

Die Aufgabe ist erst abgeschlossen, wenn:

1. MarkLook erfolgreich kompiliert.
2. Tests erfolgreich laufen.
3. Die Quick-Look-Extension korrekt eingebettet ist.
4. `.md` / `.markdown` korrekt registriert sind.
5. Markdown tatsächlich gerendert wird.
6. Light und Dark Mode funktionieren.
7. GFM-Grundfunktionen funktionieren.
8. potenziell bösartiges Markdown keine aktive Codeausführung ermöglicht.
9. die Haupt-App sinnvoll funktioniert.
10. README und Test-Markdown vorhanden sind.
11. keine relevanten Build-Warnings bestehen.
12. ein manueller Finder-Test beschrieben und vorbereitet ist.

Wenn du während der Entwicklung Verbesserungspotenzial erkennst, das ohne unnötiges Scope Creep einen deutlichen Qualitätsgewinn bringt, darfst du es umsetzen.

Priorität:

1. zuverlässige Quick-Look-Integration
2. Rendering-Qualität
3. Sicherheit
4. Performance
5. native macOS UX
6. zusätzliche Features

**Beginne jetzt mit Phase 1.**

Erstelle auch öffentliche Repo mit top doku auf englisch. die app soll semver folgen, beginne mit 0.0.1. 
die readme soll badges enthalten wie die anderen repos von mir und MIT lizenz. und spenden button paypal an martin.pfeffer@celox.io 
und zeige badges für LoC und Anzahl Unit Tests ebenfalls in der readme an. orientiere dich an meinen anderen projekten. 
