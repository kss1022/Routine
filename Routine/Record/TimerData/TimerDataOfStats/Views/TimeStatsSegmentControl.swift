//
//  TimeStatsSegmentControl.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import UIKit



class TimeStatsSegmentControl: UISegmentedControl{
    private let segmentInset: CGFloat = 8       //your inset amount
    private let segmentImage: UIImage? = UIImage(color: .systemGreen)    //your color

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
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        setTitleTextAttributes(titleTextAttributes, for: .selected)
        
    }
}
