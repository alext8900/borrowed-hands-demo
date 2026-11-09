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

    static var summary: String {
        "\(platform) build, \(configuration)"
    }
}
