import Foundation
import MarkLookCore

@MainActor
public enum HTMLSanitizerTests {
    public static func run() {
        let runner = TestRunner.shared
        runner.suite("HTMLSanitizer") {
            runner.runTest(name: "testEscapeHTML") {
                let input = "<div>Hello & \"World\" 'Test'</div>"
                let escaped = HTMLSanitizer.escapeHTML(input)
                try assertEqual(escaped, "&lt;div&gt;Hello &amp; &quot;World&quot; &#39;Test&#39;&lt;/div&gt;")
            }
            
            runner.runTest(name: "testSanitizeURLBlocksJavascript") {
                try assertEqual(HTMLSanitizer.sanitizeURL("javascript:alert(1)"), "#")
                try assertEqual(HTMLSanitizer.sanitizeURL("JAVASCRIPT:alert(1)"), "#")
                try assertEqual(HTMLSanitizer.sanitizeURL("javascript:void(0)"), "#")
                try assertEqual(HTMLSanitizer.sanitizeURL("vbscript:msgbox(1)"), "#")
                try assertEqual(HTMLSanitizer.sanitizeURL("data:text/html,<script>alert(1)</script>"), "#")
            }
            
            runner.runTest(name: "testSanitizeURLAllowsSafeSchemes") {
                try assertEqual(HTMLSanitizer.sanitizeURL("https://apple.com"), "https://apple.com")
                try assertEqual(HTMLSanitizer.sanitizeURL("http://example.com/test?a=1&b=2"), "http://example.com/test?a=1&amp;b=2")
                try assertEqual(HTMLSanitizer.sanitizeURL("mailto:support@celox.io"), "mailto:support@celox.io")
                try assertEqual(HTMLSanitizer.sanitizeURL("#section-title"), "#section-title")
                try assertEqual(HTMLSanitizer.sanitizeURL("./relative/path.md"), "./relative/path.md")
            }
            
            runner.runTest(name: "testSanitizeRawHTMLStripsScriptTags") {
                let input = "<p>Safe text</p><script>alert('XSS')</script><b>Bold</b>"
                let result = HTMLSanitizer.sanitizeRawHTML(input)
                try assertFalse(result.contains("<script>"))
                try assertFalse(result.contains("alert"))
                try assertTrue(result.contains("<p>Safe text</p>"))
                try assertTrue(result.contains("<b>Bold</b>"))
            }
            
            runner.runTest(name: "testSanitizeRawHTMLStripsIframesAndObjects") {
                let input = "<iframe src=\"https://evil.com\"></iframe><object data=\"bad\"></object>"
                let result = HTMLSanitizer.sanitizeRawHTML(input)
                try assertFalse(result.contains("<iframe"))
                try assertFalse(result.contains("<object"))
            }
            
            runner.runTest(name: "testSanitizeRawHTMLStripsEventHandlers") {
                let input = "<img src=\"foo.png\" onerror=\"alert(1)\" onload=\"exploit()\">"
                let result = HTMLSanitizer.sanitizeRawHTML(input)
                try assertFalse(result.contains("onerror"))
                try assertFalse(result.contains("onload"))
                try assertTrue(result.contains("<img src=\"foo.png\""))
            }
        }
    }
}
