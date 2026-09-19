import Foundation

public enum ExtensionStatus: Sendable, Equatable {
    case active
    case installed
    case notInstalled
    
    public var title: String {
        switch self {
        case .active: return "Installed & Active"
        case .installed: return "Installed (Disabled)"
        case .notInstalled: return "Not Registered"
        }
    }
    
    public var isOperational: Bool {
        self == .active || self == .installed
    }
}

public enum ExtensionStatusChecker {
    public static let extensionBundleId = "io.celox.marklook.preview"
    
    public static func checkStatus() -> ExtensionStatus {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/pluginkit")
        process.arguments = ["-m", "-v", "-i", extensionBundleId]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe
        
        do {
            try process.run()
            process.waitUntilExit()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8) ?? ""
            
            if output.contains(extensionBundleId) {
                if output.contains("!") || output.contains("disabled") {
                    return .installed
                }
                return .active
            }
            return .notInstalled
        } catch {
            return .notInstalled
        }
    }
}
