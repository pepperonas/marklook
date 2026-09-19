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
                try assertFalse(settings.showLineNumbers)
                try assertEqual(settings.maxFileSizeBytes, 5 * 1024 * 1024)
            }
            
            runner.runTest(name: "testSettingsEncodingDecoding") {
                var original = MarkLookSettings()
                original.appearance = .dark
                original.textSize = .large
                original.contentWidth = .wide
                original.allowRemoteImages = true
                original.enableSyntaxHighlighting = false
                original.showLineNumbers = true
                original.maxFileSizeBytes = 10 * 1024 * 1024
                
                let encoder = JSONEncoder()
                let data = try encoder.encode(original)
                
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(MarkLookSettings.self, from: data)
                
                try assertEqual(original, decoded)
            }
            
            runner.runTest(name: "testTextSizeEnumProperties") {
                try assertEqual(MarkLookTextSize.small.baseFontSizePx, 14)
                try assertEqual(MarkLookTextSize.small.codeFontSizePx, 12)
                try assertEqual(MarkLookTextSize.small.displayName, "Small")
                try assertEqual(MarkLookTextSize.small.id, "small")
                
                try assertEqual(MarkLookTextSize.standard.baseFontSizePx, 16)
                try assertEqual(MarkLookTextSize.standard.codeFontSizePx, 13)
                try assertEqual(MarkLookTextSize.standard.displayName, "Standard")
                try assertEqual(MarkLookTextSize.standard.id, "standard")
                
                try assertEqual(MarkLookTextSize.large.baseFontSizePx, 18)
                try assertEqual(MarkLookTextSize.large.codeFontSizePx, 15)
                try assertEqual(MarkLookTextSize.large.displayName, "Large")
                try assertEqual(MarkLookTextSize.large.id, "large")
            }
            
            runner.runTest(name: "testContentWidthEnumProperties") {
                try assertEqual(MarkLookContentWidth.compact.cssMaxWidth, "680px")
                try assertEqual(MarkLookContentWidth.compact.displayName, "Compact (680px)")
                
                try assertEqual(MarkLookContentWidth.standard.cssMaxWidth, "840px")
                try assertEqual(MarkLookContentWidth.standard.displayName, "Standard (840px)")
                
                try assertEqual(MarkLookContentWidth.wide.cssMaxWidth, "1040px")
                try assertEqual(MarkLookContentWidth.wide.displayName, "Wide (1040px)")
                
                try assertEqual(MarkLookContentWidth.full.cssMaxWidth, "100%")
                try assertEqual(MarkLookContentWidth.full.displayName, "Full Width")
            }
            
            runner.runTest(name: "testAppearanceEnumProperties") {
                try assertEqual(MarkLookAppearance.system.displayName, "System")
                try assertEqual(MarkLookAppearance.light.displayName, "Light")
                try assertEqual(MarkLookAppearance.dark.displayName, "Dark")
            }
            
            runner.runTest(name: "testSharedDefaultsAppGroupConstants") {
                try assertEqual(MarkLookSettings.appGroupSuiteName, "group.io.celox.marklook")
                try assertEqual(MarkLookSettings.settingsKey, "io.celox.marklook.settings")
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
