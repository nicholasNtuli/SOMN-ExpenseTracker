import SwiftUI

struct OnboardingView: View {
    
    @State private var isRotationEnabled: Bool = true
    @State private var showIndicator: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                GeometryReader {
                    let size = $0.size
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 0) {
                            ForEach(onboardingColors) { item in
                                CardView(item)
                                    .padding(.horizontal, 65)
                                    .frame(width: size.width)
                                    .visualEffect { content, geometryProxy in
                                        content
                                            .scaleEffect(scale(geometryProxy, scale: 0.1), anchor: .trailing)
                                            .rotationEffect(rotation(geometryProxy, rotation: 1.5))
                                            .offset(x: minX(geometryProxy))
                                            .offset(x: excessMinx(geometryProxy, offset: 10))
                                    }
                                    .zIndex(onboardingColors.zIndex(item))
                            }
                        }
                        .padding(.vertical, 10)
                    }
                    .scrollTargetBehavior(.paging)
                    .scrollIndicators(showIndicator ? .visible : .hidden)
                }
                .frame(height: 410)
            }
        }
    }
    
    @ViewBuilder
    func CardView(_ item: Onboarding) -> some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(item.color.gradient)
            .overlay(
                Text("Look Here!!")
                    .foregroundColor(.white)
                    .font(.title)
                    .fontWeight(.bold)
            )
    }
    
    /// Stacked Cards - Animation
    func minX(_ proxy: GeometryProxy) -> CGFloat {
        let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
        return minX < 0 ? 0 : -minX
    }
    
    func progress(_ proxy: GeometryProxy, limit: CGFloat = 2) -> CGFloat {
        let maxX = proxy.frame(in: .scrollView(axis: .horizontal)).maxX
        let width = proxy.bounds(of: .scrollView(axis: .horizontal))?.width ?? 0
        let progress = maxX / width - 1.0
        let cappedProgress = min(progress, limit)
        
        return cappedProgress
    }
    
    func scale(_ proxy: GeometryProxy, scale: CGFloat = 0.1) -> CGFloat {
        let progress = progress(proxy)
        
        return 1 - (progress * scale)
    }
    
    func excessMinx(_ proxy: GeometryProxy, offset: CGFloat = 10) -> CGFloat {
        let progress = progress(proxy)
        
        return progress * offset
    }
    
    func rotation(_ proxy: GeometryProxy, rotation: CGFloat = 10) -> Angle {
        let progress = progress(proxy)
        
        return .init(degrees: progress * rotation)
    }
}

#Preview {
    OnboardingView()
}
