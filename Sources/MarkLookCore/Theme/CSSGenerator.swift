import Foundation

public enum CSSGenerator {
    public static func generateCSS(settings: MarkLookSettings) -> String {
        let baseFontSize = settings.textSize.baseFontSizePx
        let codeFontSize = settings.textSize.codeFontSizePx
        let maxWidth = settings.contentWidth.cssMaxWidth
        
        let appearance = settings.appearance
        
        // CSS variables for light theme
        let lightVars = """
            --bg-primary: #ffffff;
            --bg-secondary: #f5f5f7;
            --bg-code: #f6f8fa;
            --bg-code-header: #eceef1;
            --bg-table-alt: #fbfbfd;
            --text-primary: #1d1d1f;
            --text-secondary: #6e6e73;
            --text-muted: #86868b;
            --link-color: #0066cc;
            --border-color: #e5e5ea;
            --border-subtle: #f0f0f2;
            --blockquote-border: #0071e3;
            --blockquote-bg: rgba(0, 113, 227, 0.04);
            --table-border: #e0e0e5;
            --hl-kw: #af00db;
            --hl-type: #2b1378;
            --hl-str: #c41a16;
            --hl-num: #1c00cf;
            --hl-com: #6e6e73;
            --hl-attr: #835200;
            --hl-fn: #0f6f7b;
            --hl-prop: #3900a0;
            --hl-op: #434346;
            --hl-tag: #0066cc;
            --badge-bg: #e5e5ea;
            --badge-text: #48484a;
        """
        
        // CSS variables for dark theme
        let darkVars = """
            --bg-primary: #1e1e1e;
            --bg-secondary: #252528;
            --bg-code: #28282b;
            --bg-code-header: #323236;
            --bg-table-alt: #222225;
            --text-primary: #f5f5f7;
            --text-secondary: #a1a1a6;
            --text-muted: #86868b;
            --link-color: #2997ff;
            --border-color: #38383a;
            --border-subtle: #2c2c2e;
            --blockquote-border: #0a84ff;
            --blockquote-bg: rgba(10, 132, 255, 0.08);
            --table-border: #38383a;
            --hl-kw: #ff7ab2;
            --hl-type: #ac80ff;
            --hl-str: #ff8170;
            --hl-num: #dabaff;
            --hl-com: #7f8c98;
            --hl-attr: #ffd866;
            --hl-fn: #66c2cd;
            --hl-prop: #78c2b4;
            --hl-op: #e0e0e0;
            --hl-tag: #5ac8fa;
            --badge-bg: #3a3a3c;
            --badge-text: #aeaeb2;
        """
        
        var rootBlock = ""
        switch appearance {
        case .light:
            rootBlock = ":root { \(lightVars) }"
        case .dark:
            rootBlock = ":root { \(darkVars) }"
        case .system:
            rootBlock = """
            :root {
                \(lightVars)
            }
            @media (prefers-color-scheme: dark) {
                :root {
                    \(darkVars)
                }
            }
            """
        }
        
        return """
        \(rootBlock)
        
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }
        
        html {
            font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text", "SF Pro Display", "Helvetica Neue", Helvetica, Arial, sans-serif;
            font-size: \(baseFontSize)px;
            line-height: 1.6;
            color: var(--text-primary);
            background-color: var(--bg-primary);
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
            text-rendering: optimizeLegibility;
        }
        
        body {
            background-color: var(--bg-primary);
            color: var(--text-primary);
            padding: 32px 24px 64px 24px;
            display: flex;
            justify-content: center;
        }
        
        .marklook-container {
            width: 100%;
            max-width: \(maxWidth);
            margin: 0 auto;
        }
        
        /* Typography */
        h1, h2, h3, h4, h5, h6 {
            font-family: -apple-system, BlinkMacSystemFont, "SF Pro Display", "Helvetica Neue", sans-serif;
            color: var(--text-primary);
            font-weight: 600;
            line-height: 1.25;
            margin-top: 1.5em;
            margin-bottom: 0.6em;
            letter-spacing: -0.015em;
        }
        
        h1:first-child, h2:first-child, h3:first-child {
            margin-top: 0;
        }
        
        h1 {
            font-size: 2.1em;
            font-weight: 700;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 0.3em;
            margin-top: 0.5em;
        }
        
        h2 {
            font-size: 1.55em;
            border-bottom: 1px solid var(--border-subtle);
            padding-bottom: 0.25em;
        }
        
        h3 { font-size: 1.25em; }
        h4 { font-size: 1.05em; }
        h5 { font-size: 0.9em; font-weight: 600; text-transform: uppercase; color: var(--text-secondary); }
        h6 { font-size: 0.8em; font-weight: 600; text-transform: uppercase; color: var(--text-muted); }
        
        p {
            margin-bottom: 1.1em;
            color: var(--text-primary);
            word-break: break-word;
        }
        
        strong { font-weight: 600; }
        em { font-style: italic; }
        del { text-decoration: line-through; color: var(--text-secondary); }
        
        /* Links */
        a {
            color: var(--link-color);
            text-decoration: none;
            transition: color 0.15s ease;
        }
        
        a:hover {
            text-decoration: underline;
        }
        
        /* Lists */
        ul, ol {
            margin-top: 0.4em;
            margin-bottom: 1.2em;
            padding-left: 1.8em;
        }
        
        li {
            margin-bottom: 0.35em;
        }
        
        li > ul, li > ol {
            margin-top: 0.2em;
            margin-bottom: 0.2em;
        }
        
        /* Task Lists */
        ul.task-list {
            list-style-type: none;
            padding-left: 0.3em;
        }
        
        li.task-list-item {
            display: flex;
            align-items: flex-start;
            margin-bottom: 0.45em;
            list-style-type: none;
        }
        
        li.task-list-item input[type="checkbox"] {
            margin-right: 0.6em;
            margin-top: 0.35em;
            cursor: default;
            accent-color: var(--link-color);
            transform: scale(1.15);
        }
        
        li.task-list-item.checked {
            color: var(--text-secondary);
        }
        
        /* Blockquotes */
        blockquote {
            margin: 1.2em 0;
            padding: 0.6em 1.2em;
            border-left: 3px solid var(--blockquote-border);
            background-color: var(--blockquote-bg);
            border-radius: 0 6px 6px 0;
            color: var(--text-secondary);
        }
        
        blockquote > p:last-child {
            margin-bottom: 0;
        }
        
        /* Horizontal Rule */
        hr {
            height: 1px;
            background-color: var(--border-color);
            border: none;
            margin: 2em 0;
        }
        
        /* Tables */
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 1.4em 0;
            font-size: 0.95em;
            border-radius: 6px;
            overflow: hidden;
            border: 1px solid var(--table-border);
        }
        
        th, td {
            padding: 9px 14px;
            text-align: left;
            border-bottom: 1px solid var(--table-border);
        }
        
        th {
            background-color: var(--bg-secondary);
            font-weight: 600;
            color: var(--text-primary);
        }
        
        tr:nth-child(even) td {
            background-color: var(--bg-table-alt);
        }
        
        tr:last-child td {
            border-bottom: none;
        }
        
        /* Code */
        code {
            font-family: ui-monospace, "SF Mono", Menlo, Monaco, Consolas, monospace;
            font-size: \(codeFontSize)px;
            background-color: var(--bg-secondary);
            color: var(--text-primary);
            padding: 0.2em 0.4em;
            border-radius: 4px;
            border: 1px solid var(--border-color);
        }
        
        pre {
            margin: 1.3em 0;
            border-radius: 8px;
            background-color: var(--bg-code);
            border: 1px solid var(--border-color);
            overflow: hidden;
            position: relative;
        }
        
        .code-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: var(--bg-code-header);
            padding: 5px 14px;
            font-size: 11px;
            font-weight: 500;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            border-bottom: 1px solid var(--border-subtle);
        }
        
        pre code {
            display: block;
            padding: 14px 16px;
            overflow-x: auto;
            border: none;
            background: transparent;
            font-size: \(codeFontSize)px;
            line-height: 1.55;
            tab-size: 4;
            white-space: pre;
        }
        
        /* Syntax highlighting tokens */
        .hl-kw { color: var(--hl-kw); font-weight: 500; }
        .hl-type { color: var(--hl-type); }
        .hl-str { color: var(--hl-str); }
        .hl-num { color: var(--hl-num); }
        .hl-com { color: var(--hl-com); font-style: italic; }
        .hl-attr { color: var(--hl-attr); }
        .hl-fn { color: var(--hl-fn); }
        .hl-prop { color: var(--hl-prop); }
        .hl-op { color: var(--hl-op); }
        .hl-punct { color: var(--text-muted); }
        .hl-tag { color: var(--hl-tag); font-weight: 500; }
        
        /* Images */
        img {
            max-width: 100%;
            height: auto;
            border-radius: 6px;
            margin: 0.8em 0;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        }
        
        .image-blocked, .image-error {
            display: inline-flex;
            align-items: center;
            padding: 6px 12px;
            font-size: 0.85em;
            color: var(--text-secondary);
            background-color: var(--bg-secondary);
            border: 1px dashed var(--border-color);
            border-radius: 4px;
            margin: 0.5em 0;
        }
        
        /* Large file warning banner */
        .marklook-warning-banner {
            background-color: rgba(255, 149, 0, 0.12);
            border-left: 4px solid #ff9500;
            padding: 12px 16px;
            border-radius: 4px;
            margin-bottom: 24px;
            font-size: 0.9em;
            color: var(--text-primary);
        }
        """
    }
}
