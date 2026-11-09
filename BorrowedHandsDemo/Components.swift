import SwiftUI

/// The hand and sparkles at the top of the screen. It bounces on every high five.
struct HeroBadge: View {
    let tint: Color
    let count: Int

    var body: some View {
        ZStack {
            Circle()
                .fill(tint.gradient)
                .frame(width: 140, height: 140)
                .shadow(color: tint.opacity(0.35), radius: 16, y: 8)
            Image(systemName: "hand.raised.fill")
                .font(.system(size: 64))
                .foregroundStyle(.white)
            Image(systemName: "sparkles")
                .font(.system(size: 30))
                .foregroundStyle(.yellow)
                .offset(x: 52, y: -52)
        }
        .symbolEffect(.bounce, value: count)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("A raised hand with sparkles")
    }
}

/// A small palette so the app has something to choose.
enum Accent: String, CaseIterable, Identifiable {
    case ocean = "Ocean"
    case sunset = "Sunset"
    case forest = "Forest"
    case grape = "Grape"

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .ocean: .blue
        case .sunset: .orange
        case .forest: .green
        case .grape: .purple
        }
    }
}

struct AccentPicker: View {
    @Binding var selection: Accent

    var body: some View {
        Picker("Accent", selection: $selection) {
            ForEach(Accent.allCases) { accent in
                Text(accent.rawValue).tag(accent)
            }
        }
        .pickerStyle(.segmented)
        .frame(maxWidth: 360)
    }
}

/// The interactive bit: count high fives, reset when you are done.
struct HighFiveCounter: View {
    @Binding var count: Int
    let tint: Color

    var body: some View {
        VStack(spacing: 12) {
            Text(count == 1 ? "1 high five" : "\(count) high fives")
                .font(.title2.monospacedDigit())
                .contentTransition(.numericText(value: Double(count)))

            HStack(spacing: 12) {
                Button {
                    withAnimation { count += 1 }
                } label: {
                    Label("High five", systemImage: "hand.wave.fill")
                }
                .buttonStyle(.borderedProminent)
                .tint(tint)

                Button("Reset") {
                    withAnimation { count = 0 }
                }
                .buttonStyle(.bordered)
                .disabled(count == 0)
            }
        }
    }
}
