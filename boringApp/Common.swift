//
//  Common.swift
//  boringApp
//
//  Created by Rodrigo Ortiz on 20/10/24.
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

struct ValidSets {
    static let username = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz0123456789._")
    static let non_letters = CharacterSet(charactersIn: "0123456789._")
    
}
