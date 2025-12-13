//
//  UIColor+Hex.swift
//  HabitTracker
//
//  Created by Danylo Onosov on 24.11.2025.
//

import UIKit

extension UIColor {
    // Returns "#RRGGBB"
    func toHexString() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 1

        // Try standard RGBA
        if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            let r = Int(round(red * 255))
            let g = Int(round(green * 255))
            let b = Int(round(blue * 255))
            return String(format: "#%02X%02X%02X", r, g, b)
        }

        // Try grayscale
        var white: CGFloat = 0
        if getWhite(&white, alpha: &alpha) {
            let v = Int(round(white * 255))
            return String(format: "#%02X%02X%02X", v, v, v)
        }

        // Fallback (should rarely happen)
        return "#000000"
    }

    // Returns "#RRGGBBAA"
    func toHexStringWithAlpha() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 1

        if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            let r = Int(round(red * 255))
            let g = Int(round(green * 255))
            let b = Int(round(blue * 255))
            let a = Int(round(alpha * 255))
            return String(format: "#%02X%02X%02X%02X", r, g, b, a)
        }

        var white: CGFloat = 0
        if getWhite(&white, alpha: &alpha) {
            let v = Int(round(white * 255))
            let a = Int(round(alpha * 255))
            return String(format: "#%02X%02X%02X%02X", v, v, v, a)
        }

        return "#000000FF"
    }
}
