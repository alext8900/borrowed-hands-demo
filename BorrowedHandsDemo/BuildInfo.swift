import Foundation

/// A one-line footer describing the platform this binary was compiled for.
enum BuildInfo {
    static var platform: String {
        #if os(macOS)
        "macOS"
        #elseif targetEnvironment(simulator)
        "iOS Simulator"
        #else
        "iOS"
        #endif
    }

    static var configuration: String {
        #if DEBUG
        "Debug"
        #else
        "Release"
        #endif
    }

    /// Marketing version from the bundle (CFBundleShortVersionString), or "dev" when absent.
    static var version: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "dev"
    }

    /// Build number from the bundle (CFBundleVersion), or "0" when absent.
    static var buildNumber: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "0"
    }

    static var summary: String {
        "\(platform) build, \(configuration)"
    }
}
