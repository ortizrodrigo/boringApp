//
//  SearchView.swift
//  boringApp
//
//  Created by Rodrigo Ortiz on 21/10/24.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var events = ["Concert", "Movie Night", "Game Day"]
    @State private var filteredEvents: [String] = []

    var body: some View {
        VStack {
            TextField("Search for events...", text: $searchText, onCommit: {
                filterEvents()
            })
            .padding()
            .background(Summer.sky)
            .cornerRadius(10)
            .padding()
            
            List(filteredEvents.isEmpty ? events : filteredEvents, id: \.self) { event in
                Text(event)
            }
            .listStyle(PlainListStyle())
            
            Spacer()
        }
        .navigationTitle("Search")
    }
    
    private func filterEvents() {
        if searchText.isEmpty {
            filteredEvents = []
        } else {
            filteredEvents = events.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

