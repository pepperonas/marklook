import Foundation

print("Starting MarkLook Test Suite...")
let start = CFAbsoluteTimeGetCurrent()

HTMLSanitizerTests.run()
ResourceResolverTests.run()
SyntaxHighlighterTests.run()
MarkdownRendererTests.run()
SettingsTests.run()
PerformanceTests.run()

let totalTime = (CFAbsoluteTimeGetCurrent() - start) * 1000
print(String(format: "Total Test Suite Time: %.2f ms", totalTime))

let success = TestRunner.shared.report()
if !success {
    exit(1)
}
exit(0)
