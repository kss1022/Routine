//
//  RullerCursorView.swift
//  Routine
//
//  Created by 한현규 on 10/27/23.
//

import UIKit



class RullerCursorView: UIView {
    
    var cursorColor: UIColor = UIColor.systemOrange
    var lineWidth: CGFloat = 3.0
    var cursorSize: CGFloat = 10.0
    
    private lazy var innerView: UIView = {
        let view = RullerCursorInverView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    init(){
        super.init(frame: .zero)        
        clipsToBounds = true
        addSubview(innerView)
        
        //let innerWidth = cursorSize - lineWidth * 2
        let inset: CGFloat = lineWidth + 1.0
        
        NSLayoutConstraint.activate([
//            innerView.widthAnchor.constraint(equalToConstant: innerWidth),
//            innerView.heightAnchor.constraint(equalToConstant: innerWidth),
//            innerView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            innerView.centerYAnchor.constraint(equalTo: centerYAnchor)
            innerView.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            innerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            innerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            innerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        
    
    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        var radius: CGFloat { (bounds.height - lineWidth) / 2 }

        let path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat.pi * 2,
            clockwise: true
        )
        cursorColor.setStroke()
        
        path.lineWidth = lineWidth
        path.stroke()
        
//        let path = UIBezierPath(ovalIn: rect)
//        cursorColor.setStroke()
//        
//        path.lineWidth = lineWidth
//        path.stroke()
        
    }
    
    func startAnimation(){
        UIView.animate(withDuration: 0.3) {
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.innerView.isHidden = true
        }
    }
    
    func endAnimation(){
        UIView.animate(withDuration: 0.3) {
            self.transform = .identity
            self.innerView.isHidden = false
        }
    }
    
    
}


private class RullerCursorInverView: UIView{
    
    var cursorColor: UIColor = UIColor.label
    
    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        var radius: CGFloat { bounds.height / 2 }

        let path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat.pi * 2,
            clockwise: true
        )
                
        //let path = UIBezierPath(ovalIn: rect)
        cursorColor.setFill()
        path.fill()
    }
}


//Triangle Cursor
//var cursorColor: CGColor = UIColor.systemOrange.cgColor
//
//override func draw(_ rect: CGRect) {
//    let width = rect.width
//    
//    UIColor.clear.set()
//    UIRectFill(self.bounds)
//    if let context = UIGraphicsGetCurrentContext(){
//        context.beginPath()
//        context.move(to: CGPoint(x: 0, y: 0))
//        context.addLine(to: CGPoint(x: width, y: 0))
//        context.addLine(to: CGPoint(x: width / 2, y: width / 2))
//        context.setLineCap(CGLineCap.butt)
//        context.setLineJoin(CGLineJoin.bevel)
//        context.closePath()
//        context.setFillColor(cursorColor)
//        context.drawPath(using: CGPathDrawingMode.fillStroke)
//    }
//}



