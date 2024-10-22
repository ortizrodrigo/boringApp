//
//  MessageView.swift
//  boringApp
//
//  Created by Rodrigo Ortiz on 21/10/24.
//

import SwiftUI

struct MessageView: View {
    var body: some View {
        VStack {
            Text("Messages")
                .font(.largeTitle)
                .foregroundColor(Summer.aqua)
            
            Divider()
            
            // Sample message list
            List {
                Text("Chat with User123")
                Text("Group Chat: Friends")
                Text("Group Chat: Family")
            }
            .listStyle(PlainListStyle())
            
            Spacer()
        }
        .padding()
        .background(Summer.white)
        .navigationTitle("Messages")
    }
}
