//
//  PreAuthView.swift
//  boringApp
//
//  Created by Rodrigo Ortiz on 18/10/24.
//

import SwiftUI

struct PreAuthView: View {
    @State private var navigateTo: String? = nil
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                Summer.white.ignoresSafeArea()
                
                VStack {
                    
                    Text("BoringApp") // CronUs
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 54, design: .default))
                        .foregroundColor(Summer.black)
                        .padding(.top, 50)
                        .padding(.bottom, 20)
                    
                    Image("AppLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                    
                    Text("Plan and Have Fun!")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    
                    Text("Accelerate Your Social Life!")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 30)
                    
                    HStack {
                        
                        NavigationLink(destination: LogInView()) {
                            Text("Log In")
                                .font(.system(size: 22))
                                .fontWeight(.semibold)
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding()
                                .background(Summer.coral)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        NavigationLink(destination: SignUpView()) {
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
            
        } // NavigationStack
        
    } // body
    
} // preAuthView

#Preview {
    PreAuthView()
}
