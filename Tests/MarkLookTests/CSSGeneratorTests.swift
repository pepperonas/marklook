import Foundation
import MarkLookCore

@MainActor
public enum CSSGeneratorTests {
    public static func run() {
        let runner = TestRunner.shared
        runner.suite("CSSGenerator") {
            runner.runTest(name: "testSystemAppearanceMediaQueries") {
                var settings = MarkLookSettings()
                settings.appearance = .system
                let css = CSSGenerator.generateCSS(settings: settings)
                
                try assertTrue(css.contains(":root {"))
                try assertTrue(css.contains("@media (prefers-color-scheme: dark)"))
                try assertTrue(css.contains("--bg-primary: #ffffff;"))
                try assertTrue(css.contains("--bg-primary: #1e1e1e;"))
            }
            
            runner.runTest(name: "testLightOnlyAppearance") {
                var settings = MarkLookSettings()
                settings.appearance = .light
                let css = CSSGenerator.generateCSS(settings: settings)
                
                try assertTrue(css.contains("--bg-primary: #ffffff;"))
                try assertFalse(css.contains("@media (prefers-color-scheme: dark)"))
            }
            
            runner.runTest(name: "testDarkOnlyAppearance") {
                var settings = MarkLookSettings()
                settings.appearance = .dark
                let css = CSSGenerator.generateCSS(settings: settings)
                
                try assertTrue(css.contains("--bg-primary: #1e1e1e;"))
                try assertFalse(css.contains("@media (prefers-color-scheme: dark)"))
            }
            
            runner.runTest(name: "testTextSizesInGeneratedCSS") {
                var smallSettings = MarkLookSettings()
                smallSettings.textSize = .small
                let smallCSS = CSSGenerator.generateCSS(settings: smallSettings)
                try assertTrue(smallCSS.contains("font-size: 14px;"))
                try assertTrue(smallCSS.contains("font-size: 12px;"))
                
                var largeSettings = MarkLookSettings()
                largeSettings.textSize = .large
                let largeCSS = CSSGenerator.generateCSS(settings: largeSettings)
                try assertTrue(largeCSS.contains("font-size: 18px;"))
                try assertTrue(largeCSS.contains("font-size: 15px;"))
            }
            
            runner.runTest(name: "testContentWidthsInGeneratedCSS") {
                var compact = MarkLookSettings()
                compact.contentWidth = .compact
                let compactCSS = CSSGenerator.generateCSS(settings: compact)
                try assertTrue(compactCSS.contains("max-width: 680px;"))
                
                var wide = MarkLookSettings()
                wide.contentWidth = .wide
                let wideCSS = CSSGenerator.generateCSS(settings: wide)
                try assertTrue(wideCSS.contains("max-width: 1040px;"))
                
                var full = MarkLookSettings()
                full.contentWidth = .full
                let fullCSS = CSSGenerator.generateCSS(settings: full)
                try assertTrue(fullCSS.contains("max-width: 100%;"))
            }
            
            runner.runTest(name: "testCoreClassesPresentInCSS") {
                let settings = MarkLookSettings()
                let css = CSSGenerator.generateCSS(settings: settings)
                
                try assertTrue(css.contains(".marklook-container"))
                try assertTrue(css.contains(".code-header"))
                try assertTrue(css.contains("blockquote"))
                try assertTrue(css.contains("table"))
                try assertTrue(css.contains(".task-list"))
                try assertTrue(css.contains(".image-blocked"))
                try assertTrue(css.contains(".image-error"))
                try assertTrue(css.contains(".hl-kw"))
                try assertTrue(css.contains(".hl-str"))
                try assertTrue(css.contains(".hl-type"))
                try assertTrue(css.contains(".hl-fn"))
                try assertTrue(css.contains(".hl-com"))
                try assertTrue(css.contains(".hl-num"))
            }
        }
    }
}
