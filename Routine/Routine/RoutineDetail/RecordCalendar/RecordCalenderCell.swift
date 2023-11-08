//
//  RecordCalenderCell.swift
//  Routine
//  FSCalendar: DIYCalendarCell
//  Created by 한현규 on 10/12/23.
//


import Foundation
import FSCalendar
import UIKit

enum SelectionType : Int {
    case none
    case single
    case leftBorder
    case middle
    case rightBorder
}


class RecordCalenderCell: FSCalendarCell {
    
    weak var circleImageView: UIImageView!
    weak var selectionLayer: CAShapeLayer!
    
    var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let todayCircleImageView = UIImageView(image: UIImage(named: "circle")!)
        todayCircleImageView.tintColor = .darkGray

        
        self.contentView.insertSubview(todayCircleImageView, at: 0)
        self.circleImageView = todayCircleImageView
        
        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = UIColor.primaryColor.cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
        self.selectionLayer = selectionLayer
        
        self.shapeLayer.isHidden = true
        
        let view = UIView(frame: self.bounds)
        view.backgroundColor = .clear//UIColor.lightGray.withAlphaComponent(0.12)
        self.backgroundView = view;
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.circleImageView.frame = self.titleLabel.bounds.insetBy(dx: -5.0, dy: -5.0)
        self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 1)
        self.selectionLayer.frame = self.titleLabel.bounds//self.contentView.bounds
        
        let bounds = self.selectionLayer.bounds
        
        
        if selectionType == .middle {
            let middleReact = CGRect(x: bounds.minX - 1, y: bounds.minY, width: bounds.width + 2, height: bounds.height)
            self.selectionLayer.path = UIBezierPath(rect: middleReact).cgPath
        }
        else if selectionType == .leftBorder {
            let leftReact = CGRect(x: bounds.minX, y: bounds.minY, width: bounds.width + 1, height: bounds.height)
            self.selectionLayer.path = UIBezierPath(roundedRect: leftReact, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2, height: self.selectionLayer.frame.width / 2)).cgPath
        }
        else if selectionType == .rightBorder {
            let rightReact = CGRect(x: bounds.minX - 1, y: bounds.minY, width: bounds.width + 1, height: bounds.height)
            self.selectionLayer.path = UIBezierPath(roundedRect: rightReact, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2, height: self.selectionLayer.frame.width / 2)).cgPath
        }
        else if selectionType == .single {
            let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
            self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.titleLabel.frame.width / 2 - diameter / 2, y: self.titleLabel.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
        }                
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        // Override the build-in appearance configuration
        if self.isPlaceholder {
            self.eventIndicator.isHidden = true
            self.titleLabel.textColor = UIColor.lightGray
        }
        
        
    }
    
}
