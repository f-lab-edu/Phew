//
//  PhewColor.swift
//  PhewComponent
//
//  Created by dong eun shin on 5/12/25.
//

import SwiftUI

@available(iOS 13.0, *)
public struct PhewColor {
    
    // MARK: - Primary Colors
    public static var primaryPurple: Color {
        adaptiveColor(light: "#6C5DD3", dark: "#CFC8FF")
    }
    
    public static var primaryGreen: Color {
        adaptiveColor(light: "#A5F59C", dark: "#A0D7E7")
    }
    
    // MARK: - Semantic Colors
    public static var semanticPink: Color {
        adaptiveColor(light: "#FFA2C0", dark: "#FFA2C0")
    }
    
    public static var semanticYellow: Color {
        adaptiveColor(light: "#FFCE73", dark: "#FFCE73")
    }
    
    public static var semanticBlue: Color {
        adaptiveColor(light: "#A0D7E7", dark: "#A0D7E7")
    }
    
    public static var semanticGreen: Color {
        adaptiveColor(light: "#A5F59C", dark: "#A5F59C")
    }
    
    public static var semanticRed: Color {
        adaptiveColor(light: "#E44F4F", dark: "#E44F4F")
    }
    
    // MARK: - Neutral Colors
    public static var neutralDark: Color {
        adaptiveColor(light: "#262A34", dark: "#5E6272")
    }
    
    public static var neutralGray: Color {
        adaptiveColor(light: "#5E6272", dark: "#808191")
    }
    
    public static var neutralLightGray: Color {
        adaptiveColor(light: "#808191", dark: "#CFC8FF")
    }
    
    public static var neutralWhite: Color {
        adaptiveColor(light: "#FFFFFF", dark: "#262A34")
    }
    
    // MARK: - Background and Foreground Colors
    public static var backgroundColor: Color {
        adaptiveColor(light: "#FFFFFF", dark: "#262A34")
    }

    public static var foregroundColor: Color {
        adaptiveColor(light: "#262A34", dark: "#FFFFFF")
    }
    
    // MARK: - Adaptive Color Method
    private static func adaptiveColor(light: String, dark: String) -> Color {
        return Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor(hex: dark) : UIColor(hex: light)
        })
    }
}

// MARK: - UIColor Extension
extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        
        let red, green, blue: CGFloat
        switch hex.count {
        case 6: // RGB (24-bit)
            red = CGFloat((int >> 16) & 0xFF) / 255.0
            green = CGFloat((int >> 8) & 0xFF) / 255.0
            blue = CGFloat(int & 0xFF) / 255.0
        default:
            red = 1.0
            green = 1.0
            blue = 1.0
        }
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
