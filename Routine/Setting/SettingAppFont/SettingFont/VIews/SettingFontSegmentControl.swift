//
//  SettingFontSegmentControl.swift
//  Routine
//
//  Created by 한현규 on 11/17/23.
//

import UIKit


final class SettingFontSegmentControl : UISegmentedControl{
    
    private let inset : CGFloat = 32.0
    private let image: UIImage? = UIImage(color: .clear)    //your color

    
    override func layoutSubviews() {
        super.layoutSubviews()
        setSegment()
    }
    
    func changeUnderlinePosition(){
        guard let underline = self.viewWithTag(1) else {return}
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        underline.frame.origin.x = underlineFinalXPosition
    }
    
    
    private func setSegment(){
        var textColorNormal: UIColor
        var textColorSelected: UIColor
        
        if self.traitCollection.userInterfaceStyle == .dark {
            textColorNormal = UIColor.gray
            textColorSelected = UIColor.white
        } else {
            textColorNormal = UIColor.gray
            textColorSelected = UIColor.black
        }
        
        let font =  UIFont.getFont(style: .footnote)

        let backgroundImage = image
        self.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)
        
        let deviderImage = image
        self.setDividerImage(deviderImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        
        
        self.removeUnderline()
        let underlineWidth: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let underlineHeight: CGFloat = 2.0
        let underlineXPosition = CGFloat(self.selectedSegmentIndex * Int(underlineWidth))
        let underLineYPosition = self.bounds.size.height - 4.0
        let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
        let underline = UIView(frame: underlineFrame)
        underline.backgroundColor = .label
        underline.tag = 1
        self.addSubview(underline)
        
        self.setTitleTextAttributes(
            [ NSAttributedString.Key.foregroundColor: textColorNormal ,
              NSAttributedString.Key.font : font],
            for: .normal)
        self.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: textColorSelected ,
             NSAttributedString.Key.font : font],
            for: .selected
        )
        
        for subview in subviews{
            adjustFontSizeWidthRecursive(view: subview)
        }
    }

    
    private func adjustFontSizeWidthRecursive(view: UIView){
        let subviews = view.subviews
        for subview in subviews {
            if subview is UILabel {
                if let label = subview as? UILabel{
                    label.adjustsFontSizeToFitWidth = true
                }
            }else {
                adjustFontSizeWidthRecursive(view: subview)
            }
        }
    }
    
    private func removeUnderline(){
        guard let underline = self.viewWithTag(1) else {return}
        underline.removeFromSuperview()
    }
    

}
