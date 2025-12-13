//
//  UIColor+Hex.swift
//  HabitTracker
//
//  Created by Alina Kharchenko on 11.12.2025.
//

import UIKit

extension UIColor {
    func toHexString() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 1

        if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            let r = Int(round(red * 255))
            let g = Int(round(green * 255))
            let b = Int(round(blue * 255))
            return String(format: "#%02X%02X%02X", r, g, b)
        }

        var white: CGFloat = 0
        if getWhite(&white, alpha: &alpha) {
            let v = Int(round(white * 255))
            return String(format: "#%02X%02X%02X", v, v, v)
        }

        return "#000000"
    }

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
