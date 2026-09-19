import Foundation

public enum MarkLookAppearance: String, CaseIterable, Identifiable, Codable, Sendable {
    case system = "system"
    case light = "light"
    case dark = "dark"
    
    public var id: String { rawValue }
    
    public var displayName: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
}

public enum MarkLookTextSize: String, CaseIterable, Identifiable, Codable, Sendable {
    case small = "small"
    case standard = "standard"
    case large = "large"
    
    public var id: String { rawValue }
    
    public var displayName: String {
        switch self {
        case .small: return "Small"
        case .standard: return "Standard"
        case .large: return "Large"
        }
    }
    
    public var baseFontSizePx: Int {
        switch self {
        case .small: return 14
        case .standard: return 16
        case .large: return 18
        }
    }
    
    public var codeFontSizePx: Int {
        switch self {
        case .small: return 12
        case .standard: return 13
        case .large: return 15
        }
    }
}

public enum MarkLookContentWidth: String, CaseIterable, Identifiable, Codable, Sendable {
    case compact = "compact"
    case standard = "standard"
    case wide = "wide"
    case full = "full"
    
    public var id: String { rawValue }
    
    public var displayName: String {
        switch self {
        case .compact: return "Compact (680px)"
        case .standard: return "Standard (840px)"
        case .wide: return "Wide (1040px)"
        case .full: return "Full Width"
        }
    }
    
    public var cssMaxWidth: String {
        switch self {
        case .compact: return "680px"
        case .standard: return "840px"
        case .wide: return "1040px"
        case .full: return "100%"
        }
    }
}

public struct MarkLookSettings: Codable, Equatable, Sendable {
    public var appearance: MarkLookAppearance
    public var textSize: MarkLookTextSize
    public var contentWidth: MarkLookContentWidth
    public var allowRemoteImages: Bool
    public var enableSyntaxHighlighting: Bool
    public var showLineNumbers: Bool
    public var maxFileSizeBytes: Int
    
    public static let appGroupSuiteName = "group.io.celox.marklook"
    public static let settingsKey = "io.celox.marklook.settings"
    
    public init(
        appearance: MarkLookAppearance = .system,
        textSize: MarkLookTextSize = .standard,
        contentWidth: MarkLookContentWidth = .standard,
        allowRemoteImages: Bool = false,
        enableSyntaxHighlighting: Bool = true,
        showLineNumbers: Bool = false,
        maxFileSizeBytes: Int = 5 * 1024 * 1024 // 5 MB
    ) {
        self.appearance = appearance
        self.textSize = textSize
        self.contentWidth = contentWidth
        self.allowRemoteImages = allowRemoteImages
        self.enableSyntaxHighlighting = enableSyntaxHighlighting
        self.showLineNumbers = showLineNumbers
        self.maxFileSizeBytes = maxFileSizeBytes
    }
    
    public static var sharedDefaults: UserDefaults {
        UserDefaults(suiteName: appGroupSuiteName) ?? .standard
    }
    
    public static func load() -> MarkLookSettings {
        let defaults = sharedDefaults
        if let data = defaults.data(forKey: settingsKey),
           let settings = try? JSONDecoder().decode(MarkLookSettings.self, from: data) {
            return settings
        }
        return MarkLookSettings()
    }
    
    public func save() {
        let defaults = Self.sharedDefaults
        if let data = try? JSONEncoder().encode(self) {
            defaults.set(data, forKey: Self.settingsKey)
        }
    }
}
