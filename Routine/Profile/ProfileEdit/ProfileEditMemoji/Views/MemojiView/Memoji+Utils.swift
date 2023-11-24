//
//  MemojiExt.swift
//  Routine
//
//  Created by 한현규 on 11/23/23.
//

import Foundation
import UIKit


extension Character {
    /// A simple emoji is one scalar and presented to the user as an Emoji
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else { return false }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }
    
    /// Checks if the scalars will be merged into an emoji
    var isCombinedIntoEmoji: Bool { unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false }
    
    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}



extension String {
    /// Returns the if the String is a single emoji
    var isSingleEmoji: Bool { count == 1 && containsEmoji }
    
    /// Returns the if the String contains at least one emoji
    var containsEmoji: Bool { contains { $0.isEmoji } }
    
    /// Returns the if the String only contains emojis
    var containsOnlyEmoji: Bool { !isEmpty && !contains { !$0.isEmoji } }
    
    var emojiString: String { emojis.map { String($0) }.reduce("", +) }
    
    var emojis: [Character] { filter { $0.isEmoji } }
    
    var emojiScalars: [UnicodeScalar] { filter { $0.isEmoji }.flatMap { $0.unicodeScalars } }
    
    //TODO: Currently the default size is 98. Anything above causes the image not suitable for Widgets since the size will be too large.
    /// Converts the string to an image.
    func toImage(size: CGFloat = 98) -> UIImage? {
        let nsString = (self as NSString)
        
        let font = UIFont.systemFont(ofSize: size, weight: .bold) // you can change your font size here
        let color = UIColor.white
        
        let stringAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ]
        let imageSize = nsString.size(withAttributes: stringAttributes)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0) //  begin image context
        UIColor.clear.set() // clear background
        UIRectFill(CGRect(origin: CGPoint(), size: imageSize)) // set rect size
        nsString.draw(at: CGPoint.zero, withAttributes: stringAttributes) // draw text within rect
        let image = UIGraphicsGetImageFromCurrentImageContext() // create image from context
        UIGraphicsEndImageContext() //  end image context
        
        return image ?? UIImage()
    }

}
