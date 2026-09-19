# MarkLook

<div align="center">

  <h1>MarkLook</h1>
  <p><strong>Fast, beautiful, native Markdown Quick Look previews for macOS.</strong></p>

[![Release](https://img.shields.io/badge/Release-v0.0.1-007AFF?logo=apple&logoColor=white)](https://github.com/pepperonas/marklook/releases)
[![Build](https://img.shields.io/badge/Build-Passing-brightgreen?logo=apple&logoColor=white)](https://github.com/pepperonas/marklook)
[![Tests](https://img.shields.io/badge/Tests-32%20passed-brightgreen?logo=apple&logoColor=white)](Tests/MarkLookTests/)
[![Lines of Code](https://img.shields.io/badge/LoC-3%2C251-blue?logo=swift&logoColor=white)](Sources/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
<br>
[![Platform](https://img.shields.io/badge/Platform-macOS%2014%2B-000000?logo=apple&logoColor=white)](https://apple.com/macos)
[![Swift](https://img.shields.io/badge/Swift-6.4-FA7343?logo=swift&logoColor=white)](https://swift.org)
[![Sandboxed](https://img.shields.io/badge/Sandbox-Hardened%20App%20Sandbox-success?logo=apple&logoColor=white)](Sources/MarkLookPreview/Resources/MarkLookPreview.entitlements)
[![Zero Telemetry](https://img.shields.io/badge/Telemetry-None%20%E2%9C%93-success)](https://github.com/pepperonas/marklook)
<br><br>
<a href="https://www.paypal.com/donate/?business=martin.pfeffer%40celox.io&item_name=MarkLook&currency_code=EUR">
  <img src="https://img.shields.io/badge/☕_Buy_the_dev_a_coffee-Donate_via_PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white" height="42" alt="Donate via PayPal" />
</a>

<br><br>

```
┌────────────────────────────────────────────────────────────┐
│  Finder → Select Any Markdown File (.md) → Press Space     │
│  Instant, beautifully rendered Markdown preview!           │
└────────────────────────────────────────────────────────────┘
```

</div>

---

## Overview

**MarkLook** is a lightweight, blazing-fast native macOS application and Quick Look Preview Extension (`io.celox.marklook.preview`) that brings rich Markdown rendering directly to the Finder.

Pressing **Space** on any `.md` or `.markdown` file instantly displays formatted typography, syntax-highlighted code blocks, GitHub-style task lists, and styled tables — without third-party web runtimes, Electron, or background daemons.

Designed according to Apple's Human Interface Guidelines, MarkLook looks and feels like a native macOS component.

---

## Highlights

- ⚡ **Instant Preview**: Fast startup using Apple's modern data-based `QLPreviewProvider` and `QLPreviewReply` APIs (macOS 12+).
- 🎨 **Native Apple HIG Design**: Typography powered by SF Pro and SF Mono with automatic Light and Dark Mode switching via `@media (prefers-color-scheme)`.
- 🛠️ **Full CommonMark & GFM Support**: Headings (H1–H6), bold, italic, strikethrough, blockquotes, ordered/unordered lists, task lists, and tables.
- 🌈 **Pure-Swift Syntax Highlighting**: In-process code tokenization for 15+ programming languages without client-side JavaScript execution.
- 🛡️ **Hardened Sandboxing**: Runs strictly isolated within macOS's App Extension Sandbox (`com.apple.security.app-sandbox`) with full path traversal and XSS protections.
- 🔒 **Zero Telemetry & Offline**: Zero network tracking, zero external scripts, with remote images blocked by default to prevent tracking pixels.
- 💻 **Companion macOS App**: Built-in interactive live preview editor, configuration panel, and real-time extension diagnostic status.

---

## Visual Demonstration

```
┌────────────────────────────────────────────────────────────────────────┐
│  [×] [-] [+]  Architecture.md — Quick Look                             │
├────────────────────────────────────────────────────────────────────────┤
│                                                                        │
│  # Architecture Overview                                               │
│                                                                        │
│  The application is built entirely in **Swift 6** and supports:        │
│                                                                        │
│  - [x] CommonMark parsing                                              │
│  - [x] GitHub Flavored Tables                                          │
│  - [x] Syntax-highlighted code blocks                                  │
│                                                                        │
│  ```swift                                                              │
│  struct ServerConfig: Codable {                                        │
│      let host: String                                                  │
│      let port: Int                                                     │
│  }                                                                     │
│  ```                                                                   │
│                                                                        │
│  | Layer             | Implementation   | Status   |                   │
│  | :---------------- | :--------------- | :------- |                   │
│  | Quick Look Engine | QLPreviewProvider| Active   |                   │
│  | Markdown Core     | swift-markdown   | Native   |                   │
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘
```

---

## Supported Markdown Features

| Feature | Syntax Example | Supported |
| :--- | :--- | :---: |
| **Headings** | `# H1` through `###### H6` with anchor IDs | ✅ |
| **Emphasis** | `**bold**`, `*italic*`, `***both***` | ✅ |
| **Strikethrough** | `~~deleted text~~` | ✅ |
| **Inline Code** | `` `let value = 10` `` | ✅ |
| **Fenced Code Blocks** | ```` ```swift ... ``` ```` with language identifier | ✅ |
| **Blockquotes** | `> Callout quote` | ✅ |
| **Lists** | `- Unordered`, `1. Ordered`, nested structures | ✅ |
| **Task Lists** | `- [x] Completed`, `- [ ] Pending` | ✅ |
| **Tables** | `\| Header \| Cell \|` with column alignments (`:---`, `:---:`) | ✅ |
| **Thematic Breaks** | `---` horizontal rules | ✅ |
| **Safe Links** | `[Title](https://example.com)` (opens in browser) | ✅ |
| **Images** | `![Alt](./images/pic.png)` (safe relative resolution) | ✅ |
| **Unicode & Emojis** | Full multilingual character sets and symbols | ✅ |

### Code Syntax Highlighting

MarkLook includes a custom tokenizer written in pure Swift supporting:

- **Languages**: Swift, Rust, Python, JavaScript, TypeScript, Go, Java, Kotlin, C/C++, HTML, CSS, JSON, YAML, XML, SQL, Shell/Bash, and Markdown.
- **Safety**: Code is pre-rendered into sanitized HTML spans (`<span class="hl-kw">...</span>`) on the host side. No JavaScript engine runs inside the preview window.

---

## Project Architecture

```
MarkLook
├── MarkLook.app (Host Application)
│   ├── Contents/MacOS/MarkLook (AppKit companion app)
│   ├── Contents/Info.plist (Registered UTTypes for .md / .markdown)
│   └── Contents/PlugIns/
│       └── MarkLookPreview.appex (Quick Look App Extension)
│           ├── Contents/MacOS/MarkLookPreview
│           └── Contents/Info.plist (QLIsDataBasedPreview = true)
│
├── MarkLookCore (Shared Swift Module)
│   ├── Markdown/
│   │   ├── MarkdownRenderer.swift (AST visitor via swift-markdown)
│   │   ├── HTMLSanitizer.swift (XSS & dangerous tag cleaner)
│   │   └── ResourceResolver.swift (Path traversal guard & relative loader)
│   ├── Highlighting/
│   │   ├── SyntaxHighlighter.swift (Pure Swift code tokenizers)
│   │   └── LanguageLexer.swift (Grammar definitions)
│   ├── Theme/
│   │   ├── CSSGenerator.swift (Apple HIG Light/Dark styling)
│   │   └── ThemeStyles.swift (Adaptive palette & metrics)
│   └── Configuration/
│       └── MarkLookSettings.swift (Shared preferences model)
│
└── MarkLookTests (Automated Test Suite)
    ├── HTMLSanitizerTests.swift
    ├── ResourceResolverTests.swift
    ├── SyntaxHighlighterTests.swift
    ├── MarkdownRendererTests.swift
    ├── SettingsTests.swift
    └── PerformanceTests.swift
```

---

## Installation & Activation

### 1. Build & Install via Script

```bash
# Clone the repository
git clone https://github.com/pepperonas/marklook.git
cd marklook

# Build and install to /Applications/MarkLook.app
./Scripts/install_app.sh
```

### 2. Enable in macOS System Settings

macOS requires one-time approval for third-party Quick Look extensions:

1. Open **System Settings** → **Privacy & Security** → **Extensions**.
2. Click **Quick Look**.
3. Toggle **MarkLook QuickLook Preview** to enabled.
4. If Finder still shows raw text, reload the generator cache:
   ```bash
   qlmanage -r && qlmanage -r cache && killall Finder
   ```

---

## Manual Verification in Finder

1. Open Finder and navigate to the project directory:
   ```bash
   open .
   ```
2. Select the included test file: **`MARKDOWN_TEST.md`**.
3. Press **Space**.
4. The native MarkLook Quick Look window appears with:
   - Formatted headings and typography
   - Syntax-highlighted code blocks
   - Rendered tables and interactive checkboxes
   - Seamless dark/light theme switching

---

## Running the Automated Test Suite

MarkLook comes with a test harness with 32 unit and benchmark tests:

```bash
swift run MarkLookTests
```

Output:
```text
Starting MarkLook Test Suite...

--- Suite: HTMLSanitizer ---
  ✓ testEscapeHTML (0.06ms)
  ✓ testSanitizeURLBlocksJavascript (0.11ms)
  ✓ testSanitizeURLAllowsSafeSchemes (1.47ms)
  ✓ testSanitizeRawHTMLStripsScriptTags (1.19ms)
  ✓ testSanitizeRawHTMLStripsIframesAndObjects (0.83ms)
  ✓ testSanitizeRawHTMLStripsEventHandlers (0.80ms)

--- Suite: ResourceResolver ---
  ✓ testResolveDataURI (0.08ms)
  ✓ testResolveRemoteImageBlockedWhenDisallowed (0.00ms)
  ✓ testResolveRemoteImageAllowedWhenEnabled (0.08ms)
  ✓ testResolveLocalRelativeImage (5.80ms)
  ✓ testPathTraversalBlocked (0.46ms)
  ✓ testMimeTypeDetection (0.11ms)

--- Suite: SyntaxHighlighter ---
  ✓ testSwiftHighlighting (0.23ms)
  ✓ testRustHighlighting (0.07ms)
  ✓ testPythonHighlighting (0.05ms)
  ✓ testSQLHighlighting (0.04ms)
  ✓ testJSONHighlighting (0.02ms)
  ✓ testEscapesRawHTMLInCode (0.03ms)

--- Suite: MarkdownRenderer ---
  ✓ testBasicMarkdownRendering (4.59ms)
  ✓ testHeadingsLevels (1.49ms)
  ✓ testTaskListRendering (0.80ms)
  ✓ testTableRendering (1.16ms)
  ✓ testBlockquoteRendering (0.58ms)
  ✓ testCodeBlockWithLanguage (0.89ms)
  ✓ testMaliciousScriptTagSanitized (1.69ms)
  ✓ testLargeFileTruncation (2.03ms)

--- Suite: Settings & Theme ---
  ✓ testSettingsDefaults (0.01ms)
  ✓ testSettingsEncodingDecoding (0.14ms)
  ✓ testCSSGeneratorWithDarkAppearance (0.01ms)
  ✓ testCSSGeneratorWithLightAppearance (0.01ms)

--- Suite: Performance Benchmarks ---
  ✓ testSmallDocumentPerformance (11.51ms)
  ✓ testMediumDocumentPerformance (30.68ms)

==================================================
TEST RESULT: SUCCESS
All 32 unit tests passed successfully!
==================================================
```

---

## Security Concept

Markdown files can originate from untrusted sources (e.g., git clones, downloads). MarkLook enforces strict security guarantees:

- **Sandboxed Execution**: The extension runs in macOS's App Extension sandbox with `com.apple.security.app-sandbox = true` and `com.apple.security.files.user-selected.read-only = true`.
- **Zero JavaScript Execution**: WebKit content execution is disabled (`allowsContentJavaScript = false`). No scripts, eval, or DOM exploits can run.
- **HTML Sanitization**: Any raw HTML embedded within Markdown is sanitized. Tags like `<script>`, `<iframe>`, `<object>`, `<embed>`, `<form>`, `<input>` and event attributes (`onclick`, `onerror`, `onload`) are stripped.
- **URL Sanitization**: Dangerous URL schemes (`javascript:`, `data:text/html`, `vbscript:`) are neutralized.
- **Path Traversal Guard**: Relative image paths are canonicalized with `resolvingSymlinksInPath()` and verified to reside inside the document's parent directory. Escapes such as `../../../../etc/passwd` are blocked.
- **Tracking Pixel Protection**: Remote images (`http://`, `https://`) can be blocked via settings to prevent IP and email read tracking.
- **Resource Limits**: Files exceeding 5 MB are truncated gracefully with a notification banner, preventing Finder stalls.

---

## Support & Donation

If you enjoy using MarkLook or if it saved you time, consider supporting independent open-source development:

<div align="center">
  <a href="https://www.paypal.com/donate/?business=martin.pfeffer%40celox.io&item_name=MarkLook&currency_code=EUR">
    <img src="https://img.shields.io/badge/Donate-PayPal-00457C?logo=paypal&logoColor=white&style=for-the-badge" alt="Donate via PayPal" />
  </a>
  <br>
  <strong>PayPal:</strong> <a href="mailto:martin.pfeffer@celox.io">martin.pfeffer@celox.io</a>
</div>

---

## License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

Developed with ❤️ by **Martin Pfeffer** ([celox.io](https://celox.io)) © 2026.
