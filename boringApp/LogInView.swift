//
//  LogInView.swift
//  boringApp
//
//  Created by Rodrigo Ortiz on 11/10/24.
//

import SwiftUI

struct LogInView: View {
    @State private var username: String = UserDefaults.standard.string(forKey: "lastUsername") ?? ""
    @State private var password: String = ""
    
    @State private var usernameValid: Bool = false
    @State private var passwordValid: Bool = false
    @State private var loggedIn: Bool = false
    @State private var goToSignUpView: Bool = false
    
    @State private var message: String = ""
    
    var body: some View {
        NavigationStack {
            VStack() {
                
                if loggedIn {
                    Text("Welcome, \(username)!")
                } else {
                    Text("Not So Boring App")
                        .font(.system(size: 54, weight: .bold, design: .default))
                        .foregroundColor(Color(red: 248/255, green: 177/255, blue: 149/255))
                        .padding(.top, 50)
                        .padding(.bottom, 20)
                    
                    Spacer()
                    
                    TextField("Username", text: $username)
                        .autocorrectionDisabled()
                        .padding(.top, 20)
                        .padding(.leading, 12)
                        .onChange(of: username) { _, newValue in
                            username = newValue.lowercased()
                            let validCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz0123456789._")
                            let filtered = username.unicodeScalars.filter { validCharacters.contains($0) }
                            username = String(String.UnicodeScalarView(filtered))
                            usernameValid = !username.isEmpty && username.count <= 30
                            UserDefaults.standard.set(username, forKey: "lastUsername")
                        }
                    
                    Divider()
                    
                    SecureField("Password", text: $password)
                        .padding(.top, 20)
                        .padding(.leading, 12)
                        .onChange(of: password) { _, newValue in
                            passwordValid = newValue.count >= 8
                        }
                    
                    Divider()
                    
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
                                .background(Color(red: 248/255, green: 187/255, blue: 128/255))
                                .cornerRadius(10)
                        }
                    )
                    .padding()
                    
                    NavigationLink(destination: SignUpView()) {
                        Text("Don't have an account? Sign Up")
                            .foregroundColor(Color(red: 248/255, green: 187/255, blue: 128/255))
                    }
                    
                }
            }
            .padding()
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
    LogInView()
}
