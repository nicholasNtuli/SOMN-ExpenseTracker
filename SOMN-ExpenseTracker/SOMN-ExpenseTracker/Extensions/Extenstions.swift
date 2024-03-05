import SwiftUI

extension [Onboarding] {
    func zIndex(_ item: Onboarding) -> CGFloat {
        if let index = firstIndex(where: { $0.id == item.id }) {
            return CGFloat(count) - CGFloat(index)
        }
        
        return .zero
    }
}
