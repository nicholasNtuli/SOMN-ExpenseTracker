import SwiftUI

struct TabBarView: View {
    
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    @State private var activeTab: Tab = .recents
    
    var body: some View {
        TabView(selection: $activeTab) {
            Text("Recents")
                .tag(Tab.recents)
                .tabItem { Tab.recents.tabContent }
            
            Text("Search")
                .tag(Tab.search)
                .tabItem { Tab.search.tabContent }
            
            Text("Charts")
                .tag(Tab.charts)
                .tabItem { Tab.charts.tabContent }
            
            Text("Settings")
                .tag(Tab.settings)
                .tabItem { Tab.settings.tabContent }
        }
        .tint(appTint)
        .fullScreenCover(isPresented: $isFirstTime, content: {
            WelcomeScreen()
                .interactiveDismissDisabled()
        })
    }
}

#Preview {
    TabBarView()
}

