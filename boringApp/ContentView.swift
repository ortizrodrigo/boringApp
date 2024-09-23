//
//  ContentView.swift
//  boringApp
//
//  Created by Rodrigo Ortiz on 16/09/24.
//

import SwiftUI

struct ContentView: View {
    @State private var username: String = UserDefaults.standard.string(forKey: "lastUsername") ?? ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            Text("Hello, \(username)!")
            
            TextField("Username", text: $username)
                            .padding()
                            .border(Color.gray, width: 1)
                            .onChange(of: username) { _, newValue in
                                UserDefaults.standard.set(newValue, forKey: "lastUsername")
                            }
            
            SecureField("Password", text: $password)
                .padding()
                .border(Color.gray, width: 1)
            
            Button("Login") {
                 // add logic
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
