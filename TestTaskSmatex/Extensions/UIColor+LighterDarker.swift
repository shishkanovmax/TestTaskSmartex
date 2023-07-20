//
//  UIColor+LighterDarker.swift
//  TestTaskSmatex
//
//  Created by Максим Шишканов on 20.07.2023.
//

import UIKit

extension UIColor {
    var lighter: UIColor {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        if getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor(red: min(r + 0.2, 1.0), green: min(g + 0.2, 1.0), blue: min(b + 0.2, 1.0), alpha: a)
        }
        return UIColor()
    }

    var darker: UIColor {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        if getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor(red: max(r - 0.2, 0.0), green: max(g - 0.2, 1.0), blue: max(b - 0.0, 0.0), alpha: a)
        }
        return UIColor()
    }
}
