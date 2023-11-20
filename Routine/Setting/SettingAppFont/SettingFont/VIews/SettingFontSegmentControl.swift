//
//  SettingFontSegmentControl.swift
//  Routine
//
//  Created by 한현규 on 11/17/23.
//

import UIKit


final class SettingFontSegmentControl : UISegmentedControl{
    
    private let inset : CGFloat = 32.0
    
    init(){
        super.init(frame: .zero)
        setupSegment(color: .label)
    }
    
    init(items : [String]){
        super.init(items: items)
        setupSegment(color: .label)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSegment(color: .label)
    }
    
    func changeUnderlinePosition(){
        guard let underline = self.viewWithTag(1) else {return}
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        underline.frame.origin.x = underlineFinalXPosition
    }
    
    
    private func setupSegment( color : UIColor) {
        DispatchQueue.main.async() {
            
            self.removeBorder()
            self.addUnderlineForSelectedSegment( color: color)
        }
    }
    
    
    
    private func removeBorder(){
        var bgcolor: CGColor
        var textColorNormal: UIColor
        var textColorSelected: UIColor
        
        if self.traitCollection.userInterfaceStyle == .dark {
            bgcolor = UIColor.black.cgColor
            textColorNormal = UIColor.gray
            textColorSelected = UIColor.white
        } else {
            bgcolor = UIColor.white.cgColor
            textColorNormal = UIColor.gray
            textColorSelected = UIColor.black
        }
        
        let font = UIFont.getFont(style: .footnote)

        let backgroundImage = UIImage.getColoredRectImageWith(color: bgcolor, andSize: self.bounds.size)
        self.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)
        
        let deviderImage = UIImage.getColoredRectImageWith(color: bgcolor, andSize: CGSize(width: 1.0, height: self.bounds.size.height))
        self.setDividerImage(deviderImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        self.setTitleTextAttributes(
            [ NSAttributedString.Key.foregroundColor: textColorNormal ,
              NSAttributedString.Key.font : font],
            for: .normal)
        self.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: textColorSelected ,
             NSAttributedString.Key.font : font],
            for: .selected
        )
        
    }
    
    
    private func addUnderlineForSelectedSegment( color : UIColor){
        DispatchQueue.main.async() {
            self.removeUnderline()
            let underlineWidth: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments)
            let underlineHeight: CGFloat = 2.0
            let underlineXPosition = CGFloat(self.selectedSegmentIndex * Int(underlineWidth))
            let underLineYPosition = self.bounds.size.height - 4.0
            let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
            let underline = UIView(frame: underlineFrame)
            underline.backgroundColor = color
            underline.tag = 1
            self.addSubview(underline)
        }
    }
    
    private func removeUnderline(){
        guard let underline = self.viewWithTag(1) else {return}
        underline.removeFromSuperview()
    }
    

}

fileprivate extension UIImage{
    
    class func getColoredRectImageWith(color: CGColor, andSize size: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let graphicsContext = UIGraphicsGetCurrentContext()
        graphicsContext?.setFillColor(color)
        let rectangle = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        graphicsContext?.fill(rectangle)
        let rectangleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rectangleImage!
    }
}
