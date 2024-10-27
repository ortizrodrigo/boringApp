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
    
    @State private var usernameErrorMsg: String = ""
    @State private var passwordErrorMsg: String = ""
    @State private var confirmPasswordErrorMsg: String = ""
    
    @State private var usernameValid: Bool = false
    @State private var passwordValid: Bool = false
    @State private var confirmPasswordValid: Bool = false

    
    var body: some View {
        
        NavigationStack {
            
            ZStack(alignment: .bottom) {
                
                VStack(spacing: 20) {
                    
                    Text("Welcome back!")
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
                    // _____ END: PASSWORD SECURE FIELD _____
                    
                    // _____ START: ERROR MESSSAGES _____
                    if !username.isEmpty && !usernameValid && !usernameErrorMsg.isEmpty {
                        Text(usernameErrorMsg)
                               .font(.footnote)
                               .foregroundColor(Summer.aqua)
                    }
            
                    Spacer()
                    
                } // END: TOP VSTACK
                
                VStack(spacing: 20) {
                    Button(
                        action: login,
                        label: {
                            Text("Log In")
                                .font(.system(size: 24, weight: .bold, design: .default))
                                .frame(width: 360, height: 60)
                                .foregroundColor(Color.white)
                                .background(Summer.coral) // Summer.sun
                                .cornerRadius(10)
                        }
                    )
                    
                    NavigationLink(destination: SignUpView()) {
                        Text("Don't have an account? Sign Up")
                            .foregroundColor(Summer.coral)
                    }
                } // _____ END: BOTTOM VSTACK
                
            } // _____ END: ZSTACK
            
        } // _____ END: NAVIGATION STACK
        
        .navigationBarBackButtonHidden(true)
        
    } // _____ END: LOG IN VIEW
    
    func login() {
        let (success, error) = KeychainHandler.verifyCredentials(username: username, password: password)
        if success {
            // _____ TBD _____
        } else {
            // _____ TBD _____
        }
    }
    
}

#Preview {
    LogInView()
}
