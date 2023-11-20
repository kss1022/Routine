//
//  RepeatSegmentControl.swift
//  Routine
//
//  Created by 한현규 on 10/9/23.
//

import UIKit




class RepeatSegmentControl: UISegmentedControl{
    private let segmentInset: CGFloat = 8       //your inset amount
    private let segmentImage: UIImage? = UIImage(color: .primaryColor)    //your color

    override func layoutSubviews(){
        super.layoutSubviews()

        //background
        layer.cornerRadius = bounds.height/2
        //foreground
        let foregroundIndex = numberOfSegments
        
        if subviews.indices.contains(foregroundIndex), let foregroundImageView = subviews[foregroundIndex] as? UIImageView
        {
            foregroundImageView.bounds = foregroundImageView.bounds.insetBy(dx: segmentInset, dy: segmentInset)
            foregroundImageView.image = segmentImage    //substitute with our own colored image
            foregroundImageView.layer.removeAnimation(forKey: "SelectionBounds")    //this removes the weird scaling animation!
            foregroundImageView.layer.masksToBounds = true
            foregroundImageView.layer.cornerRadius = foregroundImageView.bounds.height/2
        }
        
        let font: UIFont = .getFont(size: 16.0)
        let normalTextAttributes = [
            NSAttributedString.Key.font: font
        ]
        setTitleTextAttributes(normalTextAttributes, for: .normal)
        
        let selectedTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: font
        ]
        setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
    }
}
