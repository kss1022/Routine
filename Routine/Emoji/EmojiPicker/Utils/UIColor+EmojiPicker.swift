//
//  UIColor+EmojiPicker.swift
//  Routine
//
//  Created by 한현규 on 12/1/23.
//


import UIKit

extension UIColor {
    /// Color for EmojiPicker background - `.systemGroupedBackground` in UIKit.
    static let popoverBackgroundColor = UIColor(
        light:  UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0),
        dark: UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.0)
    )
    
    /// Color for `selectedBackgroundView` background in `EmojiCollectionViewCell` - `.opaqueSeparator` in UIKit.
    static let selectedCellBackgroundViewColor = UIColor(
        light: UIColor(red: 0.78, green: 0.78, blue: 0.8, alpha: 1.0),
        dark: UIColor(red: 0.28, green: 0.28, blue: 0.29, alpha: 1.0)
    )
    
    /// Color for `separatorView` background in `EmojiPickerView` - `.systemGray3` in UIKit.
    static let separatorColor = UIColor(
        light: UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1.0),
        dark: UIColor(red: 0.22, green: 0.22, blue: 0.23, alpha: 1.0)
    )
    
    /// Increases brightness or decreases saturation.
    func adjust(by percentage: CGFloat = 30.0) -> UIColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        if self.getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
            if b < 1.0 {
                let newB: CGFloat = max(min(b + (percentage/100.0) * b, 1.0), 0.0)
                return UIColor(hue: h, saturation: s, brightness: newB, alpha: a)
            } else {
                let newS: CGFloat = min(max(s - (percentage/100.0) * s, 0.0), 1.0)
                return UIColor(hue: h, saturation: newS, brightness: b, alpha: a)
            }
        }
        return self
    }
}

extension UIColor {
    /// Supports light and dark color versions.
    convenience init(light: UIColor, dark: UIColor) {
        if #available(iOS 13.0, *) {
            self.init(dynamicProvider: { trait in
                trait.userInterfaceStyle == .light ? light : dark
            })
        } else {
            self.init(cgColor: light.cgColor)
        }
    }
}
