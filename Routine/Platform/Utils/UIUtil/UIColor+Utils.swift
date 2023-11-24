import UIKit

extension UIColor {
    convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
    
    func toHex() -> String {
        if let components = self.cgColor.components{
            if components.count == 2{
                Log.v("components \(components)")
                let rgbInt = Int(components[0] * 255.0)
                let alpahInt = Int(components[1] * 255.0)
                let hex = String(format: "#%02X%02X%02X%02X", rgbInt, rgbInt, rgbInt, alpahInt)
                return hex
            }
            
            let red = components[0]
            let green = components[1]
            let blue = components[2]
            let alpha = components[3]
            
            let redInt = Int(red * 255.0)
            let greenInt = Int(green * 255.0)
            let blueInt = Int(blue * 255.0)
            let alphaInt = Int(alpha * 255.0)
            
            let hex = String(format: "#%02X%02X%02X%02X", redInt, greenInt, blueInt, alphaInt)
            return hex
        }
        return ""
    }
}


