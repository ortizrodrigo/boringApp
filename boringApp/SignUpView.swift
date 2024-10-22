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
                VStack(spacing: 20) {
                    Text("Sign Up")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 54, design: .default))
                        .foregroundColor(Summer.black)
                        .padding(.top, 50)
                        .padding(.bottom, 20)
                    
                    // Placeholder for logo
                    Image(systemName: "pencil.and.list.clipboard.rtl")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .foregroundColor(Summer.sky)
                    
                    TextField("Username", text: $username)
                        .frame(width: 300, height: 40)
                        .autocorrectionDisabled()
                        .padding(.leading, 25)
                        .padding(.trailing, 25) // Add right padding for balance
                        .padding(.vertical, 10) // Add vertical padding for better appearance
                        .background(Color.white) // Background color of the text field
                        .cornerRadius(10) // Rounded corners
                        .overlay(
                            RoundedRectangle(cornerRadius: 10) // Same corner radius as above
                                .stroke(Color.gray, lineWidth: 1) // Border color and width
                        )
                        .onChange(of: username) { _, newValue in
                            username = newValue.lowercased()
                            let filtered = username.unicodeScalars.filter { ValidSets.username.contains($0) }
                            username = String(String.UnicodeScalarView(filtered))
                            
                            if username.count > 30 {
                                username = String(username.prefix(30))
                            }
                            
                            usernameValid = !username.isEmpty && username.count <= 30
                            UserDefaults.standard.set(username, forKey: "lastUsername")
                        }
                    
                    Divider()
                    
                    SecureField("Password", text: $password)
                        .padding(.top, 20)
                        .padding(.leading, 25)
                        .onChange(of: password) { _, newValue in
                            passwordValid = newValue.count >= 8
                        }
                    
                    Divider()
                    
                    Text(message)
                        .foregroundColor(.red)
                    
                    Spacer()
                } // VStack
                
                VStack(spacing: 20) {
                    
                    Button(
                        action: signUp,
                        label: {
                            Text("Sign Up")
                                .font(.system(size: 24, weight: .bold, design: .default))
                                .frame(width: 360, height: 60)
                                .foregroundColor(Color.white)
                                .background(Color(red: 253/255, green: 219/255, blue: 115/255))
                                .cornerRadius(10)
                        }
                    )
                    
                    NavigationLink(destination: LogInView()) {
                        Text("Already have an account? Log In")
                            .foregroundColor(Color(red: 253/255, green: 219/255, blue: 115/255))
                    }
                    
                } //.......................VStack
                
            } //...........................ZStack
            
        } //.............................. Navigation Stack
        
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
