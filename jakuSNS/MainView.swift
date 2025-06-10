//
//  MainView.swift
//  jakuSNS
//
//  Created by 中村優介 on 2025/03/31.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("YouTube", systemImage: "play.rectangle")
                }

            InstagramView()
                .tabItem {
                    Label("Instagram", systemImage: "camera")
                }
        }
    }
}

#Preview {
    MainView()
}

