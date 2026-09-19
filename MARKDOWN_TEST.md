# MarkLook Visual Showcase 🚀

Welcome to the **MarkLook** visual test suite. This document serves as a comprehensive manual integration test for Finder Quick Look previews on macOS.

---

## 1. Typography & Hierarchy

# Heading 1 with Bottom Border
## Heading 2 with Subtle Divider
### Heading 3 Subsection
#### Heading 4 Sub-heading
##### Heading 5 Upper Case Muted
###### Heading 6 Minor Caption

A regular paragraph demonstrating Apple's **San Francisco (SF Pro)** system font. The rendering conforms to macOS native typography guidelines with balanced line heights, optimal character spacing, and crisp contrast in both **Light** and **Dark Mode**.

Paragraphs can contain **bold**, *italic*, ***bold italic***, ~~strikethrough text~~, and `inline code elements`. You can also include [hyperlinks to external websites](https://apple.com) that open securely in your default browser.

---

## 2. GitHub Flavored Markdown (GFM) Features

### Task Lists

- [x] Native Swift 6.4 Implementation
- [x] Apple Quick Look App Extension (`QLPreviewProvider`)
- [x] Server-side pure Swift syntax highlighting
- [x] Dark Mode and Light Mode with `@media (prefers-color-scheme)`
- [x] Sandboxed execution with zero JavaScript
- [ ] Customizable themes (Roadmap)

### Tables

| Component | Technology | Role | Status |
| :--- | :---: | :--- | :---: |
| **MarkLookCore** | Swift / CommonMark | AST Parsing & HTML generation | ✅ Complete |
| **MarkLookPreview** | QuickLookUI | macOS App Extension | ✅ Active |
| **MarkLook.app** | AppKit / WebKit | Settings & Live Preview | ✅ Stable |
| **Security Layer** | Swift Sanitizer | XSS & Path Traversal Guard | 🛡️ Protected |

---

## 3. Native Blockquotes & Callouts

> **Important Note:**
> MarkLook generates clean, semantic HTML rendered by macOS's native Quick Look WebKit daemon. No JavaScript runtime or external dependencies are required.
> 
> *Typography, margins, and colors adapt automatically when your Mac changes between Day and Night appearances.*

---

## 4. Syntax Highlighting in Code Blocks

### Swift (Quick Look Preview Provider)
```swift
import Foundation
import QuickLookUI
import MarkLookCore

@objc(PreviewProvider)
public final class PreviewProvider: QLPreviewProvider, QLPreviewingController {
    public func providePreview(
        for request: QLFilePreviewRequest,
        completionHandler: @escaping (QLPreviewReply?, (any Error)?) -> Void
    ) {
        let renderer = MarkdownRenderer()
        let html = renderer.renderHTML(markdown: "# Hello from Quick Look")
        let reply = QLPreviewReply(dataOfContentType: .html, contentSize: CGSize(width: 840, height: 640)) { _ in
            return html.data(using: .utf8) ?? Data()
        }
        completionHandler(reply, nil)
    }
}
```

### Rust (Concurrent Cache)
```rust
use std::collections::HashMap;
use std::sync::{Arc, RwLock};

pub struct SharedCache<K, V> {
    store: Arc<RwLock<HashMap<K, V>>>,
}

impl<K: Eq + std::hash::Hash + Clone, V: Clone> SharedCache<K, V> {
    pub fn get(&self, key: &K) -> Option<V> {
        let guard = self.store.read().ok()?;
        guard.get(key).cloned()
    }
}
```

### Python (Data Processing)
```python
import sys
from typing import List, Optional

def analyze_tokens(lines: List[str]) -> dict[str, int]:
    counts = {}
    for line in lines:
        for word in line.split():
            clean = word.strip().lower()
            counts[clean] = counts.get(clean, 0) + 1
    return counts
```

### SQL (Aggregations)
```sql
SELECT
    d.department_name,
    COUNT(e.id) AS employee_count,
    AVG(e.salary) AS average_salary
FROM departments d
INNER JOIN employees e ON d.id = e.department_id
WHERE e.is_active = 1
GROUP BY d.department_name
HAVING COUNT(e.id) >= 5
ORDER BY average_salary DESC;
```

### JSON Configuration
```json
{
  "name": "MarkLook",
  "bundleIdentifier": "io.celox.marklook",
  "version": "0.0.1",
  "platforms": ["macOS 14.0+"],
  "sandboxed": true
}
```

---

## 5. Lists & Nested Structures

1. First Top-Level Item
   1. Nested Numbered Item 1.1
   2. Nested Numbered Item 1.2
2. Second Top-Level Item
   - Nested Bullet Point A
   - Nested Bullet Point B
     - Deeply Nested Bullet Point B.1
3. Third Top-Level Item

---

## 6. Embedded Media & Data URLs

### Embedded Data-URI Image
![1x1 Pixel](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg== "Embedded 1x1 Pixel")

---

## 7. Unicode & Internationalization

- **German**: Übergrößenträger & Qualitätsprüfung für macOS-Vorschau.
- **Japanese**: 素晴らしいマークダウンのクイックルック体験。
- **Spanish**: Vista previa nativa de Markdown rápida y segura.
- **French**: Prévisualisation Markdown native et ultra-rapide.
- **Math & Symbols**: ∀x ∈ ℝ: e^(iπ) + 1 = 0 • ∑(k=1..n) k² = n(n+1)(2n+1)/6
- **Emojis**: 🍎 🖥️ ⚡ ☕ 📦 🔒 ✨ 🚀

---

*Document compiled for MarkLook manual verification on macOS.*
