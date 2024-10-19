//
//  PreAuthView.swift
//  boringApp
//
//  Created by Rodrigo Ortiz on 18/10/24.
//

import SwiftUI

struct Summer {
    static let sunset = Color(red: 204/255, green: 84/255, blue: 77/255)
    static let coral = Color(red: 255/255, green: 105/255, blue: 97/255)
    static let sun = Color(red: 248/255, green: 196/255, blue: 45/255)
    static let sky = Color(red: 72/255, green: 209/255, blue: 204/255)
    static let aqua = Color(red: 35/255, green: 179/255, blue: 179/255)
    
    static let white = Color.white
    static let black = Color.black
}

struct PreAuthView: View {
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        
        ZStack {
            
            Summer.white.ignoresSafeArea()
            
            
            VStack {
                
                Text("Boring App") // CronUs
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 54, design: .default))
                    .foregroundColor(Summer.black)
                    .padding(.top, 50)
                    .padding(.bottom, 20)
                
                // Placeholder for your company logo
                Image(systemName: "bubble.left.and.text.bubble.right")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .foregroundColor(Summer.sky)
                
                
                Text("Plan and Have Fun!")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                Text("Accelerate Your Social Life!")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 30)
                
                HStack {
                    Button(action: {
                        // Implement login functionality
                        print("Login tapped")
                    }) {
                        Text("Log In")
                            .font(.system(size: 22))
                            .fontWeight(.semibold)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .background(Summer.coral)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        // Implement signup functionality
                        print("Signup tapped")
                    }) {
                        Text("Sign Up")
                            .font(.system(size: 22))
                            .fontWeight(.semibold)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .background(Summer.sun)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                } // HStack
                .padding()
            } // VStack
            .padding()
        } // ZStack
    }
}

#Preview {
    PreAuthView()
}
