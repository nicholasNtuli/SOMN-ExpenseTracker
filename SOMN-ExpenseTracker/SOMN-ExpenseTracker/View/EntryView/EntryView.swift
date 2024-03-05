import SwiftUI

struct EntryView: View {
    
    @State private var showSheet: Bool = false
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    @State private var registedUser: Bool = false
    @State private var sheetHeight: CGFloat = .zero
    @State private var sheetFirstPageHeight: CGFloat = .zero
    @State private var sheetSecondPageHeight: CGFloat = .zero
    @State private var sheetScrollProgress: CGFloat = .zero
    @State private var isKeyboardShowing: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Button("Show Sheet") {
                showSheet.toggle()
            }
            .buttonStyle(.borderedProminent)
            .tint(.gray)
        }
        .padding(30)
        .sheet(isPresented: $showSheet, onDismiss: {
            sheetHeight = .zero
            sheetFirstPageHeight = .zero
            sheetSecondPageHeight = .zero
            sheetScrollProgress = .zero
        }, content: {
            GeometryReader(content: { geometry in
                let size = geometry.size
                
                ScrollViewReader(content: { proxy in
                    ScrollView(.horizontal) {
                        HStack(alignment: .top, spacing: 0) {
                            OnboardingSheet(size)
                                .id("First Page")
                            
                            LoginView(size)
                                .id("Second Page")
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.paging)
                    .scrollIndicators(.hidden)
                    .scrollDisabled(isKeyboardShowing)
                    .overlay(alignment: .topTrailing) {
                        Button(action: {
                            if sheetScrollProgress < 1 {
                                withAnimation(.snappy) {
                                    proxy.scrollTo("Second Page", anchor: .leading)
                                }
                            } else {
                                
                            }
                        }, label: {
                            Text("Continue")
                                .fontWeight(.semibold)
                                .opacity(1 - sheetScrollProgress)
                                .frame(width: 120 + (sheetScrollProgress * (registedUser ? -20 : 25)))
                                .overlay(content: {
                                    HStack(spacing: 8) {
                                        Text(registedUser ? "Login" :" Get Started")
                                    }
                                    .fontWeight(.semibold)
                                    .opacity(sheetScrollProgress)
                                })
                                .padding(.vertical, 12)
                                .foregroundStyle(.white)
                                .background(.linearGradient(colors: [.gray, .black], startPoint: .topLeading, endPoint: .bottomTrailing), in: .capsule)
                        })
                        .padding(15)
                        .offset(y: sheetHeight - 100)
                        .offset(y: sheetScrollProgress * -120)
                    }
                })
            })
            .presentationCornerRadius(30)
            .presentationDetents(sheetHeight == .zero ? [.medium] : [.height(sheetHeight)])
            .interactiveDismissDisabled()
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification), perform: { _ in
                isKeyboardShowing = true
            })
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification), perform: { _ in
                isKeyboardShowing = false
            })
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
            Text(registedUser ? "Login" : "Create an Account")
                .font(.largeTitle.bold())
            CustomTextField(hint: "Email Address", text: $emailAddress, icon: "envelop")
                .padding(.top, 20)
            CustomTextField(hint: "******", text: $password, icon: "lock", isPassword: true)
                .padding(.top, 20)
        }
        .padding(15)
        .padding(.horizontal, 10)
        .padding(.top, 15)
        .padding(.bottom, 220)
        .overlay(alignment: .bottom, content: {
            VStack(spacing: 15) {
                Group {
                    if registedUser {
                        HStack(spacing: 4) {
                            Text("Don't have an account")
                                .foregroundStyle(.gray)
                            
                            Button("Sign Up") {
                                withAnimation(.snappy) {
                                    registedUser.toggle()
                                }
                            }
                            .tint(.red)
                        }
                        .transition(.push(from: .bottom))
                    } else {
                        HStack(spacing: 4) {
                            Text("Already have an account")
                                .foregroundStyle(.gray)
                            
                            Button("Login") {
                                withAnimation(.snappy) {
                                    registedUser.toggle()
                                }
                            }
                            .tint(.red)
                        }
                        .transition(.push(from: .top))
                    }
                }
                .font(.callout)
                .textScale(.secondary)
                .padding(.bottom, registedUser ? 0 : 15)
                
                if !registedUser {
                    Text("By signing up, you are agreeing to our **[Terms & Conditons](https://apple.com)** and **[Privacy Policy](https://apple.com)**")
                        .font(.caption)
                        .tint(.red)
                        .foregroundStyle(.gray)
                        .transition(.offset(y: 100))
                }
            }
            .padding(.bottom, 15)
            .padding(.horizontal, 20)
            .multilineTextAlignment(.center)
            .frame(width: size.width)
        })
        .frame(width: size.width)
        .heightChangePreference { height in
            sheetSecondPageHeight = height
            let diff = sheetSecondPageHeight - sheetFirstPageHeight
            sheetHeight = sheetFirstPageHeight + (diff * sheetScrollProgress)
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
