//
//  MemoryView.swift
//  boringApp
//
//  Created by Rodrigo Ortiz on 21/10/24.
//

import SwiftUI

struct MemoryView: View {
    var body: some View {
        VStack {
            Text("Your Memories")
                .font(.largeTitle)
                .foregroundColor(Summer.coral)
            
            Divider()
            
            // Placeholder for media content
            Text("Add your pictures/videos here!")
                .padding()
            
            Spacer()
        }
        .padding()
        .background(Summer.white)
        .navigationTitle("Memories")
    }
}
