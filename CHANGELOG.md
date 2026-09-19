# Changelog

All notable changes to **MarkLook** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.1] - 2026-09-19

### Added
- **Native Quick Look Preview Extension** (`io.celox.marklook.preview`) implementing modern `QLPreviewProvider` and `QLPreviewReply` APIs (macOS 12.0+).
- **Core Markdown Engine**:
  - Full CommonMark & GitHub Flavored Markdown (GFM) parsing via Apple's official `swift-markdown` library.
  - Support for Headings (H1–H6) with auto-generated anchor IDs.
  - Paragraphs, Bold, Italic, Strikethrough, Blockquotes, Ordered and Unordered lists, and Nested lists.
  - GFM Tables with alignment and alternating row highlights.
  - GFM Task Lists with custom native checkboxes (`[x]`, `[ ]`).
  - Horizontal rules (`---`).
  - Safe Link handling with `target="_blank"` and `rel="noopener noreferrer"`.
- **Pure Swift Syntax Highlighting**:
  - In-process tokenizer supporting Swift, Rust, Python, JavaScript, TypeScript, HTML, CSS, JSON, YAML, XML, SQL, and Shell.
  - Zero JavaScript runtime overhead and zero client-side scripts.
- **Apple Design Language**:
  - Automatic Dark and Light mode support using CSS variables and `@media (prefers-color-scheme: dark)`.
  - System typography powered by Apple's San Francisco (`SF Pro`) and monospace font (`SF Mono`).
  - Native table styling, code block headers with language badges, and callout blockquotes.
- **Security & Sandboxing**:
  - Native App Sandbox (`com.apple.security.app-sandbox`) integration with read-only user-selected files entitlement.
  - Strict HTML Sanitization stripping dangerous tags (`<script>`, `<iframe>`, `<object>`, `<embed>`, `<style>`) and event handlers (`onerror`, `onload`, `onclick`).
  - Path Traversal Guard preventing unauthorized access to disk resources outside document directories.
  - Tracking pixel protection via optional remote image blocking.
  - Performance degradation guard: automatic safe truncation with warning banner for documents exceeding 5 MB.
- **Native AppKit Companion Application** (`MarkLook.app`):
  - Real-time Quick Look Extension status check via `pluginkit`.
  - Interactive side-by-side Markdown editor and live WebKit preview with preset sample files.
  - Configuration panel: Theme appearance (System/Light/Dark), Text Size, Content Width, Remote Images toggle, and Syntax Highlighting toggle.
  - Step-by-step Quick Look Finder activation and cache reset guide.
  - About screen with developer information and PayPal sponsorship button.
- **Automated Test Suite**:
  - 32 Unit and integration tests covering parser features, sanitization, path traversal, syntax highlighting, settings, and performance benchmarks.
- **Developer Scripts**:
  - `Scripts/build_app.sh`: Automated bundle assembly and ad-hoc codesigning.
  - `Scripts/install_app.sh`: Automatic installation to `/Applications` and Quick Look cache reload.
