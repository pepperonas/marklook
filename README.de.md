# MarkLook

<div align="center">
  <img src="assets/marklook-banner.png" alt="MarkLook - Ein minimalistischer, leistungsstarker Markdown-Viewer für macOS" width="100%">

  <br><br>

  <a href="README.md">
    <img src="https://img.shields.io/badge/Language-English-555555?style=for-the-badge&logo=apple&logoColor=white" alt="English">
  </a>
  &nbsp;
  <a href="README.de.md">
    <img src="https://img.shields.io/badge/Sprache-Deutsch-007AFF?style=for-the-badge&logo=apple&logoColor=white" alt="Deutsch">
  </a>

  <br><br>

[![Release](https://img.shields.io/badge/Release-v0.0.1-007AFF?logo=apple&logoColor=white)](https://github.com/pepperonas/marklook/releases)
[![Build](https://img.shields.io/badge/Build-Bestanden-brightgreen?logo=apple&logoColor=white)](https://github.com/pepperonas/marklook)
[![Tests](https://img.shields.io/badge/Tests-72%20Unit--Tests%20bestanden-brightgreen?logo=apple&logoColor=white)](Tests/MarkLookTests/)
[![Zeilen Code](https://img.shields.io/badge/LoC-3.251%20Zeilen%20Swift-blue?logo=swift&logoColor=white)](Sources/)
[![Lizenz: MIT](https://img.shields.io/badge/Lizenz-MIT-yellow.svg)](LICENSE)
<br>
[![Plattform](https://img.shields.io/badge/Plattform-macOS%2014%2B-000000?logo=apple&logoColor=white)](https://apple.com/macos)
[![Swift](https://img.shields.io/badge/Swift-6.4-FA7343?logo=swift&logoColor=white)](https://swift.org)
[![Sandboxed](https://img.shields.io/badge/Sandbox-App%20Sandbox%20%2B%20Read--Only-success?logo=apple&logoColor=white)](Sources/MarkLookPreview/Resources/MarkLookPreview.entitlements)
[![Offline](https://img.shields.io/badge/Funktioniert-100%25%20Offline-blue?logo=apple&logoColor=white)](https://github.com/pepperonas/marklook)
[![Keine Telemetrie](https://img.shields.io/badge/Telemetrie-Keine%20%E2%9C%93-success)](https://github.com/pepperonas/marklook)
[![Sicherheitsaudit](https://img.shields.io/badge/Sicherheit-Gepr%C3%BCft%202026--09-0e8a16?logo=github&logoColor=white)](https://github.com/pepperonas/marklook)
[![SemVer](https://img.shields.io/badge/SemVer-2.0.0-3F4551)](https://semver.org)
[![Changelog](https://img.shields.io/badge/Changelog-Keep%20a%20Changelog-E05735?logo=keepachangelog&logoColor=white)](CHANGELOG.md)
<br><br>
<a href="https://www.paypal.com/donate/?business=martin.pfeffer%40celox.io&item_name=MarkLook&currency_code=EUR">
  <img src="https://img.shields.io/badge/☕_Entwickler_einen_Kaffee_ausgeben-Spende_via_PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white" height="42" alt="Spende via PayPal" />
</a>

<br><br>

```
┌────────────────────────────────────────────────────────────┐
│  Finder → Beliebige Markdown-Datei (.md) wählen → Leertaste│
│  Sofortige, wunderschöne native Markdown-Vorschau!         │
└────────────────────────────────────────────────────────────┘
```

</div>

---

## Übersicht

**MarkLook** ist eine extrem schlanke, blitzschnelle native macOS-Anwendung und Quick Look Preview Extension (`io.celox.marklook.preview`), die reichhaltiges Markdown-Rendering direkt in den macOS Finder bringt.

Ein Druck auf die **Leertaste** bei einer beliebigen `.md`- oder `.markdown`-Datei öffnet unmittelbar formatierte Typografie, reines Swift-Syntax-Highlighting für Codeblöcke, GitHub-Tasklisten und gestaltete Tabellen – ganz ohne Drittanbieter-Web-Runtimes, Electron oder ressourcenhungrige Hintergrunddienste.

Entwickelt streng nach Apples Human Interface Guidelines fügt sich MarkLook nahtlos wie eine offizielle macOS-Systemkomponente ein.

---

## Screenshots

| Visuelle Typografie & Layout | Syntax-Highlighting | GFM-Tasklisten & Tabellen |
| :---: | :---: | :---: |
| <img src="assets/quicklook-preview.png" width="280"> | <img src="assets/quicklook-code.png" width="280"> | <img src="assets/quicklook-tables.png" width="280"> |

---

## Hauptmerkmale

- ⚡ **Sofortige Vorschau**: Schneller Start dank Apples moderner datenbasierter `QLPreviewProvider`- und `QLPreviewReply`-APIs (macOS 12.0+).
- 🎨 **Apple Designsprache**: Typografie basierend auf San Francisco (`SF Pro`) und Monospace (`SF Mono`) mit automatischem Umschalten zwischen Hell- und Dunkelmodus via `@media (prefers-color-scheme: dark)`.
- 🛠️ **Vollständige CommonMark- & GFM-Unterstützung**: Überschriften (H1–H6), Fett, Kursiv, Durchgestrichen, Zitate (Blockquotes), geordnete/ungeordnete Listen, Aufgabenlisten und Tabellen.
- 🌈 **Reines Swift-Syntax-Highlighting**: In-Process Tokenizer für 15+ Programmiersprachen ohne clientseitige JavaScript-Ausführung.
- 🛡️ **Gehärtete Sandbox**: Isoliert in macOS' App Extension Sandbox (`com.apple.security.app-sandbox`) mit integriertem Pfad-Traversal- und XSS-Schutz.
- 🔒 **Zero Telemetrie & 100% Offline**: Keine Tracker, keine externen Skripte; Remote-Bilder sind standardmäßig blockiert, um Zählpixel zu verhindern.
- 💻 **Native Begleit-App**: Integrierter interaktiver Live-Vorschaueditor, Einstellungs-Panel und Echtzeit-Statusdiagnose der Erweiterung.

---

## Unterstützte Markdown-Features

| Feature | Syntax-Beispiel | Unterstützt | Details |
| :--- | :--- | :---: | :--- |
| **Überschriften** | `# H1` bis `###### H6` | ✅ | Mit automatisch generierten Anker-IDs |
| **Hervorhebungen** | `**fett**`, `*kursiv*`, `***beides***` | ✅ | Apple SF Pro Typografie |
| **Durchgestrichen** | `~~durchgestrichen~~` | ✅ | GitHub Flavored Markdown (GFM) |
| **Inline-Code** | `` `let value = 10` `` | ✅ | SF Mono mit subtilem Rahmen |
| **Codeblöcke** | ```` ```swift ... ``` ```` | ✅ | Syntax-Highlighting mit Sprach-Badge |
| **Blockquotes** | `> Zitatblock` | ✅ | Native Apple Callout-Gestaltung |
| **Listen** | `- Ungeordnet`, `1. Geordnet` | ✅ | Kompakte Abstände, verschachtelte Listen |
| **Aufgabenlisten** | `- [x] Erledigt`, `- [ ] Offen` | ✅ | Eigene native Checkboxen |
| **Tabellen** | `\| Kopf \| Zelle \|` | ✅ | Spaltenausrichtung (`:---`, `:---:`, `---:`) |
| **Trennlinien** | `---` | ✅ | Subtile macOS-Trenner |
| **Sichere Links** | `[Titel](https://...)` | ✅ | Öffnet sicher im Standard-Browser |
| **Bilder** | `![Alt](./images/pic.png)` | ✅ | Sicheres lokales relatives Laden via Base64 |
| **Unicode & Emojis** | Mehrsprachiger Text & Emojis | ✅ | Vollständige UTF-8 Internationalisierung |

### Reines Swift-Syntax-Highlighting

MarkLook verfügt über einen eigenen, in reinem Swift geschriebenen Tokenizer:

- **Unterstützte Sprachen**: Swift, Rust, Python, JavaScript, TypeScript, Go, Java, Kotlin, C/C++, HTML, CSS, JSON, YAML, XML, SQL, Shell/Bash und Markdown.
- **Sicherheit**: Quellcode wird hostseitig in bereinigte HTML-Spans (`<span class="hl-kw">...</span>`) zerlegt. Im Vorschaufenster läuft keinerlei JavaScript-Engine.

---

## Projektarchitektur

```text
MarkLook
├── MarkLook.app (Haupt-Applikation)
│   ├── Contents/MacOS/MarkLook (AppKit Begleit-App)
│   ├── Contents/Info.plist (Registrierte UTTypes für .md / .markdown)
│   └── Contents/PlugIns/
│       └── MarkLookPreview.appex (Quick Look App Extension)
│           ├── Contents/MacOS/MarkLookPreview
│           └── Contents/Info.plist (QLIsDataBasedPreview = true)
│
├── MarkLookCore (Geteiltes Swift-Modul)
│   ├── Markdown/
│   │   ├── MarkdownRenderer.swift (AST Visitor via swift-markdown)
│   │   ├── HTMLSanitizer.swift (XSS- und Tag-Bereinigung)
│   │   └── ResourceResolver.swift (Pfad-Traversal-Schutz & Relativ-Loader)
│   ├── Highlighting/
│   │   ├── SyntaxHighlighter.swift (Reine Swift-Code-Tokenizer)
│   │   └── LanguageLexer.swift (Grammatik-Definitionen)
│   ├── Theme/
│   │   ├── CSSGenerator.swift (Apple HIG Hell/Dunkel-Styling)
│   │   └── ThemeStyles.swift (Adaptive Farbpalette & Metriken)
│   └── Configuration/
│       └── MarkLookSettings.swift (Gemeinsames Einstellungs-Modell)
│
└── MarkLookTests (Automatisierte Test-Suite)
    ├── HTMLSanitizerTests.swift
    ├── ResourceResolverTests.swift
    ├── SyntaxHighlighterTests.swift
    ├── MarkdownRendererTests.swift
    ├── SettingsTests.swift
    └── PerformanceTests.swift
```

---

## Installation & Quick Look Aktivierung

### 1. Vorkompiliertes Release herunterladen (Empfohlen)

1. Lade das neueste `MarkLook-v*.zip` aus den [GitHub Releases](https://github.com/pepperonas/marklook/releases) herunter.
2. Entpacke die Datei und ziehe `MarkLook.app` in deinen Ordner `/Applications` (Programme).
3. Starte `MarkLook.app` einmalig, um die Erweiterung im System zu registrieren.

### 2. Aus dem Quellcode bauen & installieren

```bash
# Repository klonen
git clone https://github.com/pepperonas/marklook.git
cd marklook

# Bauen und nach /Applications/MarkLook.app installieren
./Scripts/install_app.sh
```

### 3. In den macOS-Systemeinstellungen aktivieren

macOS verlangt eine einmalige Bestätigung für Quick Look-Erweiterungen von Drittanbietern:

1. Öffne **Systemeinstellungen** → **Datenschutz & Sicherheit** → **Erweiterungen**.
2. Klicke auf **Quick Look** (Übersicht).
3. Aktiviere den Schalter für **MarkLook QuickLook Preview**.
4. Falls der Finder noch die reine Textansicht zeigt, lade den Cache neu:
   ```bash
   qlmanage -r && qlmanage -r cache && killall Finder
   ```

---

## Manuelle Überprüfung im Finder

1. Öffne den Finder und navigiere in das Projektverzeichnis:
   ```bash
   open /Applications/MarkLook.app
   ```
2. Wähle die enthaltene Testdatei aus: **`MARKDOWN_TEST.md`**.
3. Drücke die **Leertaste**.
4. Das native MarkLook-Fenster erscheint mit:
   - Formatierten Überschriften und Typografie
   - Syntax-hervorgehobenen Codeblöcken
   - Gerenderten Tabellen und interaktiven Checkboxen
   - Nahtlosem automatischen Wechsel zwischen Hell- und Dunkelmodus

---

## Automatisierte Test-Suite ausführen

MarkLook enthält eine Test-Suite mit 72 Unit- und Benchmark-Tests:

```bash
swift run MarkLookTests
```

Ausgabe:
```text
Starting MarkLook Test Suite...

--- Suite: HTMLSanitizer ---
  ✓ testEscapeHTML (0.04ms)
  ✓ testSanitizeURLBlocksJavascript (0.11ms)
  ✓ testSanitizeURLEntityEncodedBypasses (1.18ms)
  ✓ testSanitizeURLAllowsSafeSchemes (0.13ms)
  ✓ testSanitizeURLTrimming (0.04ms)
  ✓ testSanitizeRawHTMLStripsScriptTags (2.18ms)
  ✓ testSanitizeRawHTMLStripsIframesAndObjects (1.01ms)
  ✓ testSanitizeRawHTMLStripsFormsAndButtons (0.83ms)
  ✓ testSanitizeRawHTMLStripsStylesAndMeta (0.85ms)
  ✓ testSanitizeRawHTMLStripsEventHandlers (0.85ms)
  ✓ testSanitizeRawHTMLStripsJavascriptInHrefAndSrc (0.95ms)

--- Suite: ResourceResolver ---
  ✓ testResolveDataURI (0.07ms)
  ✓ testResolveRemoteImageBlockedWhenDisallowed (0.01ms)
  ✓ testResolveRemoteImageAllowedWhenEnabled (0.06ms)
  ✓ testResolveLocalRelativeImage (6.62ms)
  ✓ testResolveAbsoluteDiskPath (0.63ms)
  ✓ testPathTraversalBlocked (0.44ms)
  ✓ testResolveNonExistentLocalImageReturnsError (0.16ms)
  ✓ testResolveImageWithNilDocumentURL (0.05ms)
  ✓ testMimeTypeDetectionComprehensive (1.32ms)

--- Suite: LanguageLexer & SupportedLanguages ---
  ✓ testLanguageFromIdentifierAliases (0.06ms)
  ✓ testLanguageDisplayNames (0.00ms)
  ✓ testUnknownLanguageHandling (0.00ms)
  ✓ testTokenStructInitialization (0.00ms)

--- Suite: SyntaxHighlighter ---
  ✓ testSwiftHighlighting (0.19ms)
  ✓ testRustHighlighting (0.06ms)
  ✓ testPythonHighlighting (0.04ms)
  ✓ testJavaScriptAndTypeScriptHighlighting (0.11ms)
  ✓ testJavaAndKotlinHighlighting (0.09ms)
  ✓ testSQLHighlighting (0.05ms)
  ✓ testBashHighlighting (0.03ms)
  ✓ testJSONHighlighting (0.02ms)
  ✓ testCSSHighlighting (0.04ms)
  ✓ testBlockComments (0.03ms)
  ✓ testEscapesRawHTMLInCode (0.02ms)
  ✓ testEmptyAndUnknownLanguageFallback (0.00ms)

--- Suite: MarkdownRenderer ---
  ✓ testBasicMarkdownRendering (7.56ms)
  ✓ testHeadingsLevels (1.50ms)
  ✓ testHeadingAnchorSlugGeneration (0.37ms)
  ✓ testInlineCodeRendering (0.29ms)
  ✓ testStrikethroughRendering (0.30ms)
  ✓ testThematicBreakRendering (0.34ms)
  ✓ testLinkWithTitleAndAttributes (1.06ms)
  ✓ testImageRenderingBlockedAndAllowed (1.30ms)
  ✓ testOrderedListCustomStartIndex (0.52ms)
  ✓ testTaskListRendering (0.67ms)
  ✓ testTableRendering (0.97ms)
  ✓ testBlockquoteRendering (0.50ms)
  ✓ testCodeBlockWithLanguage (1.08ms)
  ✓ testSyntaxHighlightingDisabledSetting (0.98ms)
  ✓ testPageTitleExtractionFromHeading (0.80ms)
  ✓ testMaliciousScriptTagSanitized (1.90ms)
  ✓ testLargeFileTruncation (2.82ms)

--- Suite: ExtensionStatus ---
  ✓ testExtensionStatusTitles (0.00ms)
  ✓ testExtensionStatusIsOperational (0.00ms)
  ✓ testExtensionBundleIdConstant (0.00ms)

--- Suite: Settings & Theme ---
  ✓ testSettingsDefaults (0.00ms)
  ✓ testSettingsEncodingDecoding (0.19ms)
  ✓ testTextSizeEnumProperties (0.00ms)
  ✓ testContentWidthEnumProperties (0.00ms)
  ✓ testAppearanceEnumProperties (0.00ms)
  ✓ testSharedDefaultsAppGroupConstants (0.00ms)
  ✓ testCSSGeneratorWithDarkAppearance (0.01ms)
  ✓ testCSSGeneratorWithLightAppearance (0.01ms)

--- Suite: CSSGenerator ---
  ✓ testSystemAppearanceMediaQueries (0.04ms)
  ✓ testLightOnlyAppearance (0.14ms)
  ✓ testDarkOnlyAppearance (0.14ms)
  ✓ testTextSizesInGeneratedCSS (0.32ms)
  ✓ testContentWidthsInGeneratedCSS (0.15ms)
  ✓ testCoreClassesPresentInCSS (1.36ms)

--- Suite: Performance Benchmarks ---
  ✓ testSmallDocumentPerformance (12.80ms)
  ✓ testMediumDocumentPerformance (33.75ms)

==================================================
TEST RESULT: SUCCESS
All 72 unit tests passed successfully!
==================================================
```

---

## Sicherheitsarchitektur

Markdown-Dateien können aus ungesicherten Quellen stammen (z. B. Git-Klone, Downloads). MarkLook garantiert strikte Sicherheit:

- **Sandbox-Isolation**: Die Erweiterung läuft in macOS' App Extension Sandbox mit `com.apple.security.app-sandbox = true` und `com.apple.security.files.user-selected.read-only = true`.
- **Keine JavaScript-Ausführung**: Die WebKit-Skriptausführung ist vollständig deaktiviert (`allowsContentJavaScript = false`). Weder Skripte, `eval` noch DOM-Exploits können ausgeführt werden.
- **HTML-Sanitization**: Rohes HTML innerhalb von Markdown wird bereinigt. Tags wie `<script>`, `<iframe>`, `<object>`, `<embed>`, `<form>`, `<input>` sowie Ereignisattribute (`onclick`, `onerror`, `onload`) werden restlos entfernt.
- **URL-Sanitization**: Gefährliche URL-Schemata (`javascript:`, `data:text/html`, `vbscript:`) werden neutralisiert.
- **Pfad-Traversal-Schutz**: Relative Bildpfade werden über `resolvingSymlinksInPath()` kanonisiert und darauf geprüft, dass sie innerhalb des übergeordneten Dokumentenverzeichnisses liegen. Ausbrüche wie `../../../../etc/passwd` werden blockiert.
- **Schutz vor Zählpixeln**: Externe Bilder (`http://`, `https://`) können in den Einstellungen blockiert werden, um IP- und Tracking-Pixel zu unterbinden.
- **Ressourcenbegrenzung**: Dateien über 5 MB werden sicher und kontrolliert mit einem Hinweishinweis gekürzt, um Finder-Hänger zu verhindern.

---

## Unterstützung & Spenden

Wenn dir MarkLook gefällt oder es dir Zeit spart, freuen wir uns über deine Unterstützung der unabhängigen Open-Source-Entwicklung:

<div align="center">
  <a href="https://www.paypal.com/donate/?business=martin.pfeffer%40celox.io&item_name=MarkLook&currency_code=EUR">
    <img src="https://img.shields.io/badge/Spenden-PayPal-00457C?logo=paypal&logoColor=white&style=for-the-badge" alt="Spende via PayPal" />
  </a>
  <br>
  <strong>PayPal:</strong> <a href="mailto:martin.pfeffer@celox.io">martin.pfeffer@celox.io</a>
</div>

---

## Lizenz

Dieses Projekt steht unter der **MIT-Lizenz** — siehe [LICENSE](LICENSE) für Details.

Entwickelt mit ❤️ von **Martin Pfeffer** ([celox.io](https://celox.io)) © 2026.
