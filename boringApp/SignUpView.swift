//
//  SignUpView.swift
//  boringApp
//
//  Created by Rodrigo Ortiz on 11/10/24.
//

import SwiftUI

struct SignUpView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var message: String = ""
    @State private var usernameValid: Bool = false
    @State private var passwordValid: Bool = false
    @State private var goToLogInView: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("Sign Up")
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
                    action: signUp,
                    label: {
                        Text("Sign Up")
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .frame(maxWidth: .infinity, maxHeight: 60)
                            .foregroundColor(Color.white)
                            .background(Color(red: 253/255, green: 219/255, blue: 115/255))
                            .cornerRadius(10)
                    }
                )
                .padding()
                
                NavigationLink(destination: LogInView()) {
                    Text("Already have an account? Log In")
                        .foregroundColor(Color(red: 253/255, green: 219/255, blue: 115/255))
                }
                
            }
            .padding()
        }
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
    
}

#Preview {
    SignUpView()
}
