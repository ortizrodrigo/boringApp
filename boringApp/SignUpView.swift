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
    @State private var confirmPassword: String = ""
    
    @State private var usernameErrorMsg: String = ""
    @State private var passwordErrorMsg: String = ""
    @State private var confirmPasswordErrorMsg: String = ""
    
    @State private var usernameValid: Bool = false
    @State private var passwordValid: Bool = false
    @State private var confirmPasswordValid: Bool = false

    var body: some View {
        
        NavigationStack {
            
            ZStack(alignment: .bottom) {
                
                Summer.white.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    Text("Create an account")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 40, design: .default))
                        .foregroundColor(Summer.black)
                        .padding(.top, 50)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Image("AppLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 160, height: 160)
                    
                    // _____ START: USERNAME TEXT FIELD _____
                    TextField("Username", text: $username)
                        .frame(width: 300, height: 50)
                        .autocorrectionDisabled()
                        .padding(.leading, 25)
                        .padding(.trailing, 25)
                        .background(Summer.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .onChange(of: username) { _, newValue in
                            // Standarize all usernames as lowercase
                            username = newValue.lowercased()
                            
                            // Ensure the error message is reset between changes to username
                            usernameErrorMsg = ""
                            
                            // Prevent users from typing more than 30 characters
                            if username.count > 30 {
                                username = String(username.prefix(30))
                            }
                            
                            // Check for leading or trailing periods.
                            if username.hasPrefix(".") || username.hasSuffix(".") {
                                usernameErrorMsg = "Usernames cannot start or end with a period ('.')."
                            }
                            
                            // Check minimum length (max length of 30 already imposed on textField)
                            if username.count < 3 {
                                usernameErrorMsg = "Usernames must have at least 3 characters."
                            }
                            
                            // Check for and filter valid characters
                            let filteredAny = username.unicodeScalars.filter {
                                ValidSets.username.contains($0)
                            }
                            if filteredAny.count != username.count {
                                usernameErrorMsg = "Usernames can only use letters, numbers, underscores and periods."
                            }
                            
                            // Check for and filter numbers, periods, and underscores
                            let filteredNonLetters = username.unicodeScalars.filter {
                                ValidSets.non_letters.contains($0)
                            }
                            if filteredNonLetters.count == username.count {
                                usernameErrorMsg = "Usernames must include at least one letter (a-z)."
                            }
                            
                            // Check for consecutive periods and ellipsis unicode character
                            if username.contains("..") || username.contains("…") {
                                usernameErrorMsg = "Usernames cannot contain consecutive periods."
                            }
                            
                            // Username's validity for processing and error message display
                            usernameValid = usernameErrorMsg.isEmpty
                            
                            // Store last username
                            UserDefaults.standard.set(username, forKey: "lastUsername")
                        }
                    // _____ END: USERNAME TEXT FIELD _____
                    
                    // _____ START: PASSWORD SECURE FIELD _____
                    SecureField("Password", text: $password)
                        .frame(width: 300, height: 50)
                        .autocorrectionDisabled()
                        .padding(.leading, 25)
                        .padding(.trailing, 25)
                        .background(Summer.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .onChange(of: password) { _, newValue in
                            // Ensure the error message is reset between changes to password
                            passwordErrorMsg = ""
                            
                            if newValue.count < 12 {
                                passwordErrorMsg = "Passwords must have at least 12 characters."
                            }
                            
                            // Password's validity for processing and error message display
                            passwordValid = passwordErrorMsg.isEmpty && newValue.count >= 12
                        }
                    // _____ END: PASSWORD SECURE FIELD _____
                    
                    // _____ START: CONFIRM PASSWORD SECURE FIELD _____
                    SecureField("Confirm Password", text: $confirmPassword)
                        .frame(width: 300, height: 50)
                        .autocorrectionDisabled()
                        .padding(.leading, 25)
                        .padding(.trailing, 25)
                        .background(Summer.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .onChange(of: confirmPassword) { _, newValue in
                            // Ensure the error message is reset between changes to confirm password
                            confirmPasswordErrorMsg = ""
                            
                            if newValue != password {
                                confirmPasswordErrorMsg = "Passwords do no match."
                            }
                            
                            // Confirm Password's validity for processing and error message display
                            confirmPasswordValid = confirmPasswordErrorMsg.isEmpty
                        }
                    // _____ END: CONFIRM PASSWORD SECURE FIELD _____
                    
                    // _____ START: ERROR MESSSAGES _____
                    if !username.isEmpty && !usernameValid && !usernameErrorMsg.isEmpty {
                        Text(usernameErrorMsg)
                               .font(.footnote)
                               .foregroundColor(Summer.aqua)
                    }
                    
                    if !password.isEmpty && !passwordValid && !passwordErrorMsg.isEmpty {
                        Text(passwordErrorMsg)
                               .font(.footnote)
                               .foregroundColor(Summer.aqua)
                    }
                    
                    if !confirmPassword.isEmpty && !confirmPasswordValid && !confirmPasswordErrorMsg.isEmpty {
                        Text(confirmPasswordErrorMsg)
                               .font(.footnote)
                               .foregroundColor(Summer.aqua)
                    }
                    // _____ END: ERROR MESSSAGES _____
                    
                    Spacer()
                } // _____ END: TOP VSTACK
                
                VStack(spacing: 20) {
                    
                    Button(
                        action: signUp,
                        label: {
                            Text("Sign Up")
                                .font(.system(size: 24, weight: .bold, design: .default))
                                .frame(width: 360, height: 60)
                                .foregroundColor(Color.white)
                                .background(Summer.sun) // Summer.sun
                                .cornerRadius(10)
                        }
                    )
                    
                    NavigationLink(destination: LogInView()) {
                        Text("Already have an account? Log In")
                            .foregroundColor(Summer.sun)
                    }
                    
                } // _____ END: BOTTOM VSTACK
                
            } // _____ END: ZSTACK
            
        } // _____ END: NAVIGATION STACK
        
        .navigationBarBackButtonHidden(true)
        
    } // _____ END: SIGN UP VIEW _____
    
    func signUp() {
        if KeychainHandler.userExists(username: username) {
            usernameErrorMsg = "Username already exists!"
        } else {
            if let error = KeychainHandler.storeCredentials(username: username, password: password) {
                usernameErrorMsg = "Sign up failed: \(error)"
            } else {
                usernameErrorMsg = "Sign up successful! Please log in."
            }
        }
    }
    
}

#Preview {
    SignUpView()
}
