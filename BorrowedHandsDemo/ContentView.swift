import SwiftUI

struct ContentView: View {
    // @AppStorage rather than @State on purpose: in the Xcode 27 SDK @State is a Swift macro,
    // and the Borrowed Hands build sandbox cannot run macro plugins. Bonus: the count survives a relaunch.
    @AppStorage("highFives") private var highFives = 0
    @AppStorage("accent") private var accent: Accent = .ocean

    var body: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 0)

            HeroBadge(tint: accent.color, count: highFives)

            VStack(spacing: 8) {
                Text("Built by Hermes")
                    .font(.largeTitle.weight(.bold))
                Text("Built on a borrowed Mac mini")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("Version \(BuildInfo.version)")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                Text("Compiled on your Mac by Borrowed Hands")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            .multilineTextAlignment(.center)

            AccentPicker(selection: $accent)

            HighFiveCounter(count: $highFives, tint: accent.color)

            Spacer(minLength: 0)

            Text(BuildInfo.summary)
                .font(.footnote.monospaced())
                .foregroundStyle(.tertiary)
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(accent.color.opacity(0.08))
        .animation(.spring(duration: 0.35), value: accent)
    }
}

// PreviewProvider rather than #Preview, for the same no-macros reason.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
