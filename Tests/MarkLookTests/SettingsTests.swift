import Foundation
import MarkLookCore

@MainActor
public enum SettingsTests {
    public static func run() {
        let runner = TestRunner.shared
        runner.suite("Settings & Theme") {
            runner.runTest(name: "testSettingsDefaults") {
                let settings = MarkLookSettings()
                try assertEqual(settings.appearance, .system)
                try assertEqual(settings.textSize, .standard)
                try assertEqual(settings.contentWidth, .standard)
                try assertFalse(settings.allowRemoteImages)
                try assertTrue(settings.enableSyntaxHighlighting)
                try assertEqual(settings.maxFileSizeBytes, 5 * 1024 * 1024)
            }
            
            runner.runTest(name: "testSettingsEncodingDecoding") {
                var original = MarkLookSettings()
                original.appearance = .dark
                original.textSize = .large
                original.contentWidth = .wide
                original.allowRemoteImages = true
                original.enableSyntaxHighlighting = false
                
                let encoder = JSONEncoder()
                let data = try encoder.encode(original)
                
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(MarkLookSettings.self, from: data)
                
                try assertEqual(original, decoded)
            }
            
            runner.runTest(name: "testCSSGeneratorWithDarkAppearance") {
                var settings = MarkLookSettings()
                settings.appearance = .dark
                let css = CSSGenerator.generateCSS(settings: settings)
                try assertTrue(css.contains("--bg-primary: #1e1e1e;"))
                try assertTrue(css.contains("--text-primary: #f5f5f7;"))
            }
            
            runner.runTest(name: "testCSSGeneratorWithLightAppearance") {
                var settings = MarkLookSettings()
                settings.appearance = .light
                let css = CSSGenerator.generateCSS(settings: settings)
                try assertTrue(css.contains("--bg-primary: #ffffff;"))
                try assertTrue(css.contains("--text-primary: #1d1d1f;"))
            }
        }
    }
}
