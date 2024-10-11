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
    
    @State private var usernameValid: Bool = false
    @State private var passwordValid: Bool = false
    
    @State private var loggedIn: Bool = false
    @State private var message: String = ""
    
    var body: some View {
        VStack() {
            
            if loggedIn {
                Text("Welcome, \(username)!")
            } else {
                
                Spacer()
                
                Text("Please log in or sign up.")
                
                TextField("Username", text: $username)
                    .autocorrectionDisabled()
                    .padding()
                    .border(usernameValid ? Color.green : Color.gray, width: 3)
                    .onChange(of: username) { _, newValue in
                        username = newValue.lowercased()
                        
                        let validCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz0123456789._")
                        let filtered = username.unicodeScalars.filter { validCharacters.contains($0) }
                        
                        username = String(String.UnicodeScalarView(filtered))
                        
                        usernameValid = !username.isEmpty && username.count <= 30

                        UserDefaults.standard.set(username, forKey: "lastUsername")
                    }
                
                SecureField("Password", text: $password)
                    .padding()
                    .border(passwordValid ? Color.green : Color.gray, width: 3)
                    .onChange(of: password) { _, newValue in
                        // Validate password: at least 8 characters
                        passwordValid = newValue.count >= 8
                    }
                       
                Text(message)
                    .foregroundColor(.red)
                
                Spacer()
                
                Button(
                    action: login,
                    label: {
                        Text("Login")
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .frame(maxWidth: .infinity, maxHeight: 60)
                            .foregroundColor(Color.white)
                            .background(Color(red: 248/255, green: 187/255, blue: 128/255)) // f67280
                            .cornerRadius(10)
                    }
                )
                .padding()
                
                Button("Sign Up") {
                    signUp()
                }
                
            }
        }
        .padding()
    }
    
    func signUp() {
        if KeychainHandler.userExists(username: username) {
            message = "Username already exists!"
        } else {
            if let error = KeychainHandler.storeCredentials(username: username, password: password) {
                message = "Sign up failed: \(error)"
            } else {
                message = "Sign up successful! Please log in."
            }
        }
    }
    
    func login() {
        let (success, error) = KeychainHandler.verifyCredentials(username: username, password: password)
        if success {
            loggedIn = true
            message = "Login successful!"
        } else {
            message = "Login failed: \(error?.localizedDescription ?? "Unknown error")"
        }
    }
    
}

#Preview {
    ContentView()
}
