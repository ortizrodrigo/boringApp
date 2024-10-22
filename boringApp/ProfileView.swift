//
//  ProfileView.swift
//  boringApp
//
//  Created by Rodrigo Ortiz on 21/10/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            Text("Profile")
                .font(.largeTitle)
                .foregroundColor(Summer.sunset)
            
            Divider()
            
            // Example user information
            VStack(alignment: .leading) {
                Text("Username: User123")
                Text("Name: John Doe")
                Text("Age: 25")
            }
            .padding()
            
            Spacer()
        }
        .padding()
        .background(Summer.white)
        .navigationTitle("Profile")
    }
}
