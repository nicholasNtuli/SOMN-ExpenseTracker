import SwiftUI

struct EntryView: View {
    
    @State private var showSheet: Bool = false
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    @State private var sheetHeight: CGFloat = .zero
    @State private var sheetFirstPageHeight: CGFloat = .zero
    @State private var sheetSecondPageHeight: CGFloat = .zero
    @State private var sheetScrollProgress: CGFloat = .zero
    
    var body: some View {
        VStack {
            Spacer()
            
            Button("Show Sheet") {
                showSheet.toggle()
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
        }
        .padding(30)
        .sheet(isPresented: $showSheet, onDismiss: {
            
        }, content: {
            GeometryReader(content: { geometry in
                let size = geometry.size
                
                ScrollView(.horizontal) {
                    HStack(alignment: .top, spacing: 0) {
                        OnboardingSheet(size)
                        
                        LoginView(size)
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.paging)
                .scrollIndicators(.hidden)
            })
            .presentationCornerRadius(30)
            .presentationDetents(sheetHeight == .zero ? [.medium] : [.height(sheetHeight)])
            .interactiveDismissDisabled()
        })
    }
    @ViewBuilder
    func OnboardingSheet(_ size: CGSize) -> some View {
        VStack(alignment: .leading, spacing: 12, content: {
            Text("Stay on top of\nexpensive traits")
                .font(.largeTitle.bold())
                .lineLimit(12)
            
            Text(attributedSubTitle)
                .font(.callout)
                .foregroundStyle(.gray)
        })
        .padding(15)
        .padding(.horizontal, 10)
        .padding(.top, 15)
        .padding(.bottom, 130)
        .frame(width: size.width, alignment: .leading)
        .heightChangePreference { height in
            sheetFirstPageHeight = height
            sheetHeight = height
        }
    }
    
    var attributedSubTitle: AttributedString {
        let string = "Start now and learn more about your expenses instantly"
        var attString = AttributedString(stringLiteral: string)
        if let range = attString.range(of: "your expenses") {
            attString[range].foregroundColor = .black
            attString[range].font = .callout.bold()
        }
        
        return attString
    }
    
    @ViewBuilder
    func LoginView(_ size: CGSize) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Craete an Account")
                .font(.largeTitle.bold())
            CustomTextField(hint: "Email Address", text: $emailAddress, icon: "envelop")
                .padding(.top, 20)
            CustomTextField(hint: "******", text: $password, icon: "lock", isPassword: true)
                .padding(.top, 20)
        }
        .padding(15)
        .padding(.horizontal, 10)
        .padding(.top, 15)
        .padding(.bottom, 200)
        .frame(width: size.width)
        .heightChangePreference { height in
            sheetSecondPageHeight = height
        }
        .minXChangePreference { minX in
            let diff = sheetSecondPageHeight - sheetFirstPageHeight
            let trancatedMinX = min(size.width - minX, size.width)
            
            guard trancatedMinX > 0 else { return }
            
            let progress = trancatedMinX / size.width
            
            sheetScrollProgress = progress
            sheetHeight = sheetFirstPageHeight + (diff * progress)
        }
    }
}

#Preview {
    EntryView()
}
