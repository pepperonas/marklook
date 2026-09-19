import Foundation
import MarkLookCore

@MainActor
public enum SyntaxHighlighterTests {
    public static func run() {
        let runner = TestRunner.shared
        runner.suite("SyntaxHighlighter") {
            runner.runTest(name: "testSwiftHighlighting") {
                let code = "func greet(name: String) -> Bool { return true }"
                let highlighted = SyntaxHighlighter.shared.highlight(code: code, languageIdentifier: "swift")
                try assertTrue(highlighted.contains("hl-kw"))
                try assertTrue(highlighted.contains("func"))
                try assertTrue(highlighted.contains("hl-type"))
                try assertTrue(highlighted.contains("String"))
            }
            
            runner.runTest(name: "testRustHighlighting") {
                let code = "pub fn add(a: i32, b: i32) -> i32 { a + b }"
                let highlighted = SyntaxHighlighter.shared.highlight(code: code, languageIdentifier: "rust")
                try assertTrue(highlighted.contains("hl-kw"))
                try assertTrue(highlighted.contains("pub"))
                try assertTrue(highlighted.contains("fn"))
            }
            
            runner.runTest(name: "testPythonHighlighting") {
                let code = "def test():\n    # A comment\n    return 'success'"
                let highlighted = SyntaxHighlighter.shared.highlight(code: code, languageIdentifier: "python")
                try assertTrue(highlighted.contains("hl-kw"))
                try assertTrue(highlighted.contains("def"))
                try assertTrue(highlighted.contains("hl-com"))
                try assertTrue(highlighted.contains("hl-str"))
            }
            
            runner.runTest(name: "testSQLHighlighting") {
                let code = "SELECT name, age FROM users WHERE active = 1"
                let highlighted = SyntaxHighlighter.shared.highlight(code: code, languageIdentifier: "sql")
                try assertTrue(highlighted.contains("hl-kw"))
                try assertTrue(highlighted.contains("SELECT"))
                try assertTrue(highlighted.contains("FROM"))
            }
            
            runner.runTest(name: "testJSONHighlighting") {
                let code = "{\"name\": \"MarkLook\", \"version\": 1}"
                let highlighted = SyntaxHighlighter.shared.highlight(code: code, languageIdentifier: "json")
                try assertTrue(highlighted.contains("hl-prop"))
                try assertTrue(highlighted.contains("hl-str"))
                try assertTrue(highlighted.contains("hl-num"))
            }
            
            runner.runTest(name: "testEscapesRawHTMLInCode") {
                let code = "<script>alert('test')</script>"
                let highlighted = SyntaxHighlighter.shared.highlight(code: code, languageIdentifier: "html")
                try assertFalse(highlighted.contains("<script>"))
                try assertTrue(highlighted.contains("&lt;script&gt;"))
            }
        }
    }
}
