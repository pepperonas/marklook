import Foundation
import MarkLookCore

@MainActor
public enum PerformanceTests {
    public static func run() {
        let runner = TestRunner.shared
        runner.suite("Performance Benchmarks") {
            runner.runTest(name: "testSmallDocumentPerformance") {
                let smallMD = "# Header\n\nA small paragraph with **bold** text.\n"
                let renderer = MarkdownRenderer()
                
                let startTime = CFAbsoluteTimeGetCurrent()
                for _ in 0..<100 {
                    _ = renderer.renderHTML(markdown: smallMD)
                }
                let elapsed = CFAbsoluteTimeGetCurrent() - startTime
                
                // 100 renders of a small document should be under 0.5s
                try assertLessThan(elapsed, 0.5, "100 small documents took \(elapsed)s")
            }
            
            runner.runTest(name: "testMediumDocumentPerformance") {
                var mediumMD = "# Performance Benchmark\n\n"
                for i in 1...200 {
                    mediumMD += "## Section \(i)\n\nParagraph text with *italic* and `code`.\n\n```swift\nlet item\(i) = \(i)\n```\n\n"
                }
                
                let renderer = MarkdownRenderer()
                let startTime = CFAbsoluteTimeGetCurrent()
                let html = renderer.renderHTML(markdown: mediumMD)
                let elapsed = CFAbsoluteTimeGetCurrent() - startTime
                
                try assertFalse(html.isEmpty)
                // A 50 KB markdown file should parse and render in under 0.2s
                try assertLessThan(elapsed, 0.2, "Medium document took \(elapsed)s")
            }
        }
    }
}
