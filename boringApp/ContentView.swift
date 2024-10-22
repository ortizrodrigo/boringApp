//
//  ContentView.swift
//  boringApp
//
//  Created by Rodrigo Ortiz on 16/09/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: ProfileView()) {
                    Text("Go to Profile")
                        .padding()
                        .background(Summer.sky)
                        .foregroundColor(Summer.white)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: SearchView()) {
                    Text("Search for Events")
                        .padding()
                        .background(Summer.sun)
                        .foregroundColor(Summer.white)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: MapView()) {
                    Text("View Nearby Activities")
                        .padding()
                        .background(Summer.coral)
                        .foregroundColor(Summer.white)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: MemoryView()) {
                    Text("Your Memories")
                        .padding()
                        .background(Summer.aqua)
                        .foregroundColor(Summer.white)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: MessageView()) {
                    Text("Messages")
                        .padding()
                        .background(Summer.sunset)
                        .foregroundColor(Summer.white)
                        .cornerRadius(10)
                }
                
                Spacer()
            }
            .navigationTitle("Main Menu")
            .padding()
        }
    }
}


#Preview {
    ContentView()
}
