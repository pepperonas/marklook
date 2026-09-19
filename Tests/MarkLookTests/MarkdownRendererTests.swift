import Foundation
import MarkLookCore

@MainActor
public enum MarkdownRendererTests {
    public static func run() {
        let runner = TestRunner.shared
        runner.suite("MarkdownRenderer") {
            runner.runTest(name: "testBasicMarkdownRendering") {
                let md = """
                # My Document
                
                This is a paragraph with **bold** and *italic* text.
                
                - Item 1
                - Item 2
                """
                let renderer = MarkdownRenderer()
                let html = renderer.renderHTML(markdown: md)
                
                try assertTrue(html.contains("<h1 id=\"my-document\">My Document</h1>"))
                try assertTrue(html.contains("<strong>bold</strong>"))
                try assertTrue(html.contains("<em>italic</em>"))
                try assertTrue(html.contains("<ul>"))
                try assertTrue(html.contains("<li>Item 1</li>"))
            }
            
            runner.runTest(name: "testHeadingsLevels") {
                let md = """
                # H1
                ## H2
                ### H3
                #### H4
                ##### H5
                ###### H6
                """
                let renderer = MarkdownRenderer()
                let html = renderer.renderHTML(markdown: md)
                
                try assertTrue(html.contains("<h1 id=\"h1\">H1</h1>"))
                try assertTrue(html.contains("<h2 id=\"h2\">H2</h2>"))
                try assertTrue(html.contains("<h3 id=\"h3\">H3</h3>"))
                try assertTrue(html.contains("<h4 id=\"h4\">H4</h4>"))
                try assertTrue(html.contains("<h5 id=\"h5\">H5</h5>"))
                try assertTrue(html.contains("<h6 id=\"h6\">H6</h6>"))
            }
            
            runner.runTest(name: "testTaskListRendering") {
                let md = """
                - [x] Finished task
                - [ ] Unfinished task
                """
                let renderer = MarkdownRenderer()
                let html = renderer.renderHTML(markdown: md)
                
                try assertTrue(html.contains("class=\"task-list\""))
                try assertTrue(html.contains("type=\"checkbox\" disabled checked"))
                try assertTrue(html.contains("type=\"checkbox\" disabled>"))
            }
            
            runner.runTest(name: "testTableRendering") {
                let md = """
                | Fruit | Color |
                | :--- | :--- |
                | Apple | Red |
                | Banana | Yellow |
                """
                let renderer = MarkdownRenderer()
                let html = renderer.renderHTML(markdown: md)
                
                try assertTrue(html.contains("<table>"))
                try assertTrue(html.contains("<th>Fruit</th>"))
                try assertTrue(html.contains("<td>Red</td>"))
            }
            
            runner.runTest(name: "testBlockquoteRendering") {
                let md = "> This is an Apple-style callout."
                let renderer = MarkdownRenderer()
                let html = renderer.renderHTML(markdown: md)
                
                try assertTrue(html.contains("<blockquote>"))
                try assertTrue(html.contains("This is an Apple-style callout."))
            }
            
            runner.runTest(name: "testCodeBlockWithLanguage") {
                let md = """
                ```swift
                let x = 42
                ```
                """
                let renderer = MarkdownRenderer()
                let html = renderer.renderHTML(markdown: md)
                
                try assertTrue(html.contains("<pre>"))
                try assertTrue(html.contains("class=\"code-header\""))
                try assertTrue(html.contains("Swift"))
                try assertTrue(html.contains("<code class=\"language-swift\">"))
            }
            
            runner.runTest(name: "testMaliciousScriptTagSanitized") {
                let md = """
                # Hello
                
                <script>alert('pwned')</script>
                
                [Click me](javascript:alert(1))
                """
                let renderer = MarkdownRenderer()
                let html = renderer.renderHTML(markdown: md)
                
                try assertFalse(html.contains("<script>"))
                try assertFalse(html.contains("javascript:alert"))
                try assertTrue(html.contains("href=\"#\""))
            }
            
            runner.runTest(name: "testLargeFileTruncation") {
                var settings = MarkLookSettings()
                settings.maxFileSizeBytes = 1000 // artificially low for test
                
                let largeMD = String(repeating: "Line of text\n", count: 200)
                let renderer = MarkdownRenderer(settings: settings)
                let html = renderer.renderHTML(markdown: largeMD)
                
                try assertTrue(html.contains("marklook-warning-banner"))
                try assertTrue(html.contains("Large document truncated"))
            }
        }
    }
}
