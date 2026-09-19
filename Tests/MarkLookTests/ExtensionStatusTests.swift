import Foundation
import MarkLookCore

@MainActor
public enum ExtensionStatusTests {
    public static func run() {
        let runner = TestRunner.shared
        runner.suite("ExtensionStatus") {
            runner.runTest(name: "testExtensionStatusTitles") {
                try assertEqual(ExtensionStatus.active.title, "Installed & Active")
                try assertEqual(ExtensionStatus.installed.title, "Installed (Disabled)")
                try assertEqual(ExtensionStatus.notInstalled.title, "Not Registered")
            }
            
            runner.runTest(name: "testExtensionStatusIsOperational") {
                try assertTrue(ExtensionStatus.active.isOperational)
                try assertTrue(ExtensionStatus.installed.isOperational)
                try assertFalse(ExtensionStatus.notInstalled.isOperational)
            }
            
            runner.runTest(name: "testExtensionBundleIdConstant") {
                try assertEqual(ExtensionStatusChecker.extensionBundleId, "io.celox.marklook.preview")
            }
        }
    }
}
