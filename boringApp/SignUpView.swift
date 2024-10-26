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

    var body: some View {
        
        NavigationStack {
            
            ZStack(alignment: .bottom) {
                
                Summer.white.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    Text("Create a Boring Account")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 44, design: .default))
                        .foregroundColor(Summer.black)
                        .padding(.top, 50)
                        .padding(.bottom, 20)
                    
                    Image(systemName: "shared.with.you")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .foregroundColor(Summer.aqua)
                        .padding(.bottom, 20)
                    
                    TextField("Username", text: $username)
                        .frame(width: 300, height: 40)
                        .autocorrectionDisabled()
                        .padding(.leading, 25)
                        .padding(.trailing, 25)
                        .padding(.vertical, 10)
                        .background(Summer.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10) // Same corner radius as above
                                .stroke(Color.gray, lineWidth: 1) // Border color and width
                        )
                        .onChange(of: username) { _, newValue in
                            username = newValue.lowercased()
                            let filtered = username.unicodeScalars.filter {
                                ValidSets.username.contains($0)
                            }
                            
                            username = String(String.UnicodeScalarView(filtered))
                            if username.count > 30 {
                                username = String(username.prefix(30))
                            }
                            
                            usernameValid = !username.isEmpty && username.count <= 30
                            UserDefaults.standard.set(username, forKey: "lastUsername")
                        }
                    
                    SecureField("Password", text: $password)
                        .frame(width: 300, height: 40)
                        .autocorrectionDisabled()
                        .padding(.leading, 25)
                        .padding(.trailing, 25)
                        .padding(.vertical, 10)
                        .background(Summer.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10) // Same corner radius as above
                                .stroke(Color.gray, lineWidth: 1) // Border color and width
                        )
                        .onChange(of: password) { _, newValue in
                            passwordValid = newValue.count >= 8
                        }
                    
                    Text(message)
                        .foregroundColor(.red)
                    
                    Spacer()
                } // Top VStack
                
                VStack(spacing: 20) {
                    
                    Button(
                        action: signUp,
                        label: {
                            Text("Sign Up")
                                .font(.system(size: 24, weight: .bold, design: .default))
                                .frame(width: 360, height: 60)
                                .foregroundColor(Color.white)
                                .background(Summer.sun)
                                .cornerRadius(10)
                        }
                    )
                    
                    NavigationLink(destination: LogInView()) {
                        Text("Already have an account? Log In")
                            .foregroundColor(Summer.sun)
                    }
                    
                } // Bottom VStack
                
            } // ZStack
            
        } // Navigation Stack
        
        .navigationBarBackButtonHidden(true)
        
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
