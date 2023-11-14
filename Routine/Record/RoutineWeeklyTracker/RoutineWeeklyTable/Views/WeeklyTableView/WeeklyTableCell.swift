//
//  WeeklyTableCell.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import UIKit


final class WeeklyTableCell: UICollectionViewCell{
    
    private var selectionLayer: CAShapeLayer!
    private var dividerLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView(){
        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = UIColor.primaryColor.cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.addSublayer(selectionLayer)
        self.selectionLayer = selectionLayer
        
        let dividerLayer = CAShapeLayer()
        dividerLayer.fillColor = UIColor.clear.cgColor
        dividerLayer.strokeColor = UIColor.tertiaryLabel.cgColor
        dividerLayer.lineWidth = 0.5
        self.contentView.layer.addSublayer(dividerLayer)
        self.dividerLayer = dividerLayer
    }
    
    override func layoutSubviews() {
        self.selectionLayer.frame = self.contentView.bounds
        
        let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width) * 0.6
        self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
        
        
        self.dividerLayer.frame = self.contentView.bounds
        self.dividerLayer.path = UIBezierPath(rect: dividerLayer.frame).cgPath
    }
    
    
    func bindView(done: Bool, fillColor: UIColor?){
        self.selectionLayer.isHidden = !done
                
        if let fillColor = fillColor{
            self.selectionLayer.fillColor = fillColor.cgColor
        }        
    }
}


