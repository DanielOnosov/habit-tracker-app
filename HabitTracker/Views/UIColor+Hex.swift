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

extension UIColor {
    convenience init?(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }

        guard hexString.count == 6 || hexString.count == 8 else { return nil }

        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)

        let r, g, b, a: CGFloat
        if hexString.count == 6 {
            r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgbValue & 0x0000FF) / 255.0
            a = 1.0
        } else { // 8 chars with alpha
            r = CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgbValue & 0x000000FF) / 255.0
        }

        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

