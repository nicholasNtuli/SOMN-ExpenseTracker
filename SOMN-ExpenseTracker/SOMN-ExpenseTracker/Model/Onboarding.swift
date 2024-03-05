import SwiftUI

struct Onboarding: Identifiable {
    var id: UUID = .init()
    var color: Color
}

var onboardingColors: [Onboarding] = [
    .init(color: .red),
    .init(color: .blue),
    .init(color: .green),
    .init(color: .yellow),
    .init(color: .pink),
    .init(color: .purple)
]
