//
//  TempView.swift
//  boringApp
//
//  Created by Rodrigo Ortiz on 21/10/24.
//

import SwiftUI

struct TempView: View {
    var body: some View {
        TabView {
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
            
            MemoryView()
                .tabItem {
                    Label("Memories", systemImage: "photo.fill")
                }
            
            MessageView()
                .tabItem {
                    Label("Messages", systemImage: "bubble.right.fill")
                }
        }
        .accentColor(Summer.sun) // Change accent color of tab items
    }
        //.frame(width: 200, height: 200)
}

#Preview {
    TempView()
}
