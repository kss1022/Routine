//
//  BottomLiseTextFeild.swift
//  Routine
//
//  Created by 한현규 on 2023/09/26.
//


import UIKit


class BottomLineTextField: UITextField{
    
    private var strokeColor : CGColor = UIColor.secondaryLabel.cgColor
    private var lineHeight : CGFloat = 1.0
   
    private var addedLayer: CAShapeLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.borderStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.borderStyle = .none
    }
    
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//
//        setBottomLayer()
//    }
    
    private func setBottomLayer(){
        addedLayer?.removeFromSuperlayer()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor =  strokeColor
        shapeLayer.lineWidth = lineHeight
        //shapeLayer.lineDashPattern = dashPattern
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x:  0, y: self.frame.height + 10.0),
                                CGPoint(x: self.frame.width , y: self.frame.height + 10.0)])
        
        shapeLayer.path = path
        
        self.addedLayer = shapeLayer
        layer.addSublayer(shapeLayer)        
    }

    
    func setStrokeColor( strokeColor : CGColor ){
        self.strokeColor = strokeColor
    }

    
    func setLineHeight( height : CGFloat ){
        lineHeight = height
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setBottomLayer()
    }
    
    
}
