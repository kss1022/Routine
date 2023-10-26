//
//  SetFocusTimeControl.swift
//  Routine
//  https://github.com/DanielYK/SwiftRulerView/tree/master
//  Created by 한현규 on 10/25/23.
//

import UIKit


protocol ScrollRullerDelegate: NSObjectProtocol {
    func dyScrollRulerViewValueChange(rulerView:ScrollRuller,value:CGFloat)
}

class ScrollRuller: UIView {
    
    private let collectionViewheight = 70
    private let cursorSize = 16
    private let rulerSpacing = 10
    
    
    weak var delegate:ScrollRullerDelegate?
    
    var stepNum = 0
    
    var rulerUnit: String = ""
    var minValue: CGFloat
    var maxValue: CGFloat
    var step: CGFloat
    var num: Int
    
    private let textFeild: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isUserInteractionEnabled = true
        textField.defaultTextAttributes = [.font: UIFont.systemFont(ofSize: 19)]
        textField.textAlignment = .right
        textField.keyboardType = .numbersAndPunctuation
        textField.returnKeyType = .done
        return textField
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout  = UICollectionViewFlowLayout()
        layout.scrollDirection  = UICollectionView.ScrollDirection.horizontal
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        //collectionView.bounces = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(cellType: TimerRulerHeaderCell.self)
        collectionView.register(cellType: TimerRullerFooterCell.self)
        collectionView.register(cellType: TimerRullerCell.self)
        
        collectionView.delegate   = self
        collectionView.dataSource = self
        
        
        return collectionView
    }()
    
    private let cursorView: UIView = {
        let cursorView = RullerCursorView()
        cursorView.translatesAutoresizingMaskIntoConstraints = false
        cursorView.backgroundColor = UIColor.clear
        cursorView.triangleColor = .orange
        return cursorView
    }()
    
    //0 , 23 , 0.2, 5
    init(minValue:CGFloat, maxValue:CGFloat, step:CGFloat , num:Int) {
        self.minValue =  minValue
        self.maxValue =  maxValue
        self.step =  step
        self.num =  num
        self.stepNum = Int( (maxValue -  minValue) / step ) / num
        super.init(frame: .zero)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setView(){
        addSubview(textFeild)
        addSubview(collectionView)
        addSubview(cursorView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: CGFloat(collectionViewheight)),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            cursorView.bottomAnchor.constraint(equalTo: collectionView.topAnchor),
            cursorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            cursorView.widthAnchor.constraint(equalToConstant: CGFloat(cursorSize)),
            cursorView.heightAnchor.constraint(equalToConstant: CGFloat(cursorSize)),
            
            textFeild.bottomAnchor.constraint(equalTo: cursorView.topAnchor),
            textFeild.centerXAnchor.constraint(equalTo: centerXAnchor),
            
        ])
        
    }
    

    @objc
    private func setRealValueAndAnimated(realValue:CGFloat,animated:Bool){
        textFeild.text = String.init(format: "%.1f", min(realValue * step + minValue, maxValue) )
        //collectionView.setContentOffset(CGPoint.init(x: Int(realValue)*rulerSpacing, y: 0), animated: animated) //round(realValue)
    }
    
    
    //    func scrollToValue(value: Float){
    //        if value >= maxValue{
    //            textFeild.text = String.init(format: "%.1f", maxValue)
    //            self.perform(#selector(self.didChangeCollectionValue), with: nil, afterDelay: 0)
    //        }else if value <= minValue{
    //            textFeild.text = String.init(format: "%.1f", minValue)
    //            self.perform(#selector(self.didChangeCollectionValue), with: nil, afterDelay: 1)
    //        }else{
    //            NSObject.cancelPreviousPerformRequests(withTarget: self)
    //            self.perform(#selector(self.didChangeCollectionValue), with: nil, afterDelay: 1)
    //        }
    //    }
    
    //    @objc
    //    private func didChangeCollectionValue() {
    //        let textFieldValue = Float(textFeild.text!)
    //        if (textFieldValue! - minValue) >= 0 {
    //            self.setRealValueAndAnimated(realValue: (textFieldValue!-minValue) / step, animated: true)
    //        }
    //    }
}

extension ScrollRuller:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2 + stepNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: TimerRulerHeaderCell.self)
            cell.backgroundColor = UIColor.clear
            cell.headerMinValue = Int(minValue)
            cell.clipsToBounds = true
            return cell
        }else if indexPath.item == stepNum+1 {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: TimerRullerFooterCell.self)
            cell.backgroundColor = .clear
            cell.footerMaxValue = Int(maxValue)
            cell.clipsToBounds = true
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: TimerRullerCell.self)
            cell.backgroundColor = .clear
            cell.minValue = step*CGFloat((indexPath.item-1))*CGFloat(num)+minValue
            cell.maxValue = step*CGFloat(indexPath.item)*CGFloat(num)
            cell.step = step
            cell.num = num
            cell.rulerSpacing = CGFloat(rulerSpacing)
            cell.setNeedsDisplay()
            return cell
        }
        
    }
    
    
    
    
}
extension ScrollRuller: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = Int(scrollView.contentOffset.x) / rulerSpacing
        let totalValue = CGFloat(value) * step + minValue
        
        if totalValue >= maxValue {
            textFeild.text = String.init(format: "%.1f", maxValue)
        }else if totalValue <= minValue {
            textFeild.text = String.init(format: "%.1f", minValue)
        }else{
            textFeild.text = String.init(format: "%.1f", CGFloat(value)*step+minValue)
        }
        
        delegate?.dyScrollRulerViewValueChange(rulerView: self, value: totalValue)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.setRealValueAndAnimated(realValue: CGFloat(scrollView.contentOffset.x) / CGFloat(rulerSpacing), animated: true)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.setRealValueAndAnimated(realValue: CGFloat(scrollView.contentOffset.x) / CGFloat(rulerSpacing), animated: true)
    }
}


//300.0 -> for bounce
extension ScrollRuller: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 || indexPath.item == stepNum + 1 {
            return CGSize(width: Int(self.frame.size.width / 2) + 300, height: collectionViewheight)
        }
        return CGSize(width: rulerSpacing * num, height: collectionViewheight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 0.0, left: -300.0, bottom: 0.0, right: -298.0 + CGFloat(step)  )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}




class RullerCursorView: UIView {
    
    var triangleColor: UIColor?
    
    override func draw(_ rect: CGRect) {
        let width = rect.width
        
        UIColor.clear.set()
        UIRectFill(self.bounds)
        
        let context = UIGraphicsGetCurrentContext()
        
        context!.beginPath()
        context!.move(to: CGPoint.init(x: 0, y: 0))
        context!.addLine(to: CGPoint.init(x: width, y: 0))
        context!.addLine(to: CGPoint.init(x: width / 2, y: width / 2))
        context!.setLineCap(CGLineCap.butt)
        context!.setLineJoin(CGLineJoin.bevel)
        context!.closePath()
        
        triangleColor?.setFill()
        triangleColor?.setStroke()
        
        context!.drawPath(using: CGPathDrawingMode.fillStroke)
    }
    
}



//MARK: BaseCell
class TimerRullerCell: UICollectionViewCell {
    var minValue:CGFloat = 0.0
    var maxValue:CGFloat = 0.0
    var step:CGFloat = 0.0
    var num = 0
    
    var font: UIFont = .systemFont(ofSize: 11)
    var circleRadius: CGFloat = 1.0
    lazy var bigCircleRaidus: CGFloat = circleRadius * 2
    var rulerSpacing: CGFloat = 10.0
    
    override func draw(_ rect: CGRect) {
        let centerY = rect.size.height / 2
        
        let context = UIGraphicsGetCurrentContext()
        
        for i in 0...num {
            //context?.move(to: CGPoint.init(x: centerX * CGFloat(i), y: 0.0))
            if i % num == 0 {
//                let num = CGFloat(i) * step + minValue
//                let numStr = String(format: "%.f", num)
//                
//                let attribute:Dictionary = [
//                    NSAttributedString.Key.font: font,
//                    NSAttributedString.Key.foregroundColor: UIColor.label
//                ]
//                
//                let width = numStr.boundingRect(
//                    with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
//                    options: NSStringDrawingOptions.usesLineFragmentOrigin,
//                    attributes: attribute,context: nil
//                ).size.width
//                
//                numStr.draw(
//                    in: CGRect.init(
//                        x: centerX * CGFloat(i) - width / 2,
//                        y: 10.0, //longLineY+10
//                        width: width,
//                        height: 14.0
//                    ),
//                    withAttributes: attribute
//                )
                
                context?.addEllipse(in: CGRect(x: rulerSpacing * CGFloat(i), y: centerY - bigCircleRaidus / 2 , width: bigCircleRaidus, height: bigCircleRaidus))
            }else{
                context?.addEllipse(in: CGRect(x: rulerSpacing * CGFloat(i), y: centerY  - circleRadius / 2, width: circleRadius, height: circleRadius))
            }
            context?.strokePath()
        }
        
    }
}

//MARK: HeaderCell
class TimerRulerHeaderCell: UICollectionViewCell {
    
    var headerMinValue = 0
    var font: UIFont = .systemFont(ofSize: 11)
    var bigCircleRaidus: CGFloat = 2.0

    override func draw(_ rect: CGRect) {
        
        let centerY = rect.size.height / 2
        
//        let numStr:NSString = NSString(format: "%d", headerMinValue)
//        let attribute:Dictionary = [
//            NSAttributedString.Key.font:font,
//            NSAttributedString.Key.foregroundColor: UIColor.label
//        ]
//        
//        let width = numStr.boundingRect(
//            with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
//            options: NSStringDrawingOptions(rawValue: 0),
//            attributes: attribute,
//            context: nil
//        ).size.width
//        
//        numStr.draw(
//            in: CGRect.init(
//                x: rect.size.width-width/2,
//                y: 10.0, //longLineY+10
//                width: width,
//                height: 14.0
//            ),
//            withAttributes: attribute
//        )
        let context = UIGraphicsGetCurrentContext()
        context?.addEllipse(in: CGRect(x: rect.width, y: centerY - bigCircleRaidus / 2 , width: bigCircleRaidus, height: bigCircleRaidus))
        context?.strokePath()

        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: -300.0, y: centerY))
        path.addLine(to: CGPoint(x: rect.size.width - 10.0 , y: centerY))
        UIColor.label.setStroke()
        
        path.lineWidth = 0.5
        path.stroke()
    }
}

//MARK: FooterCell
class TimerRullerFooterCell: UICollectionViewCell {
    
    var footerMaxValue = 23
    var font: UIFont = .systemFont(ofSize: 11)
    var bigCircleRaidus: CGFloat = 2.0

    override func draw(_ rect: CGRect) {
        //let longLineY = Int(rect.size.height) - RulerShort
        let centerY = rect.size.height / 2
        
        
//        let numStr:NSString = NSString(format: "%d", footerMaxValue)
//        let attribute:Dictionary = [
//            NSAttributedString.Key.font: font,
//            NSAttributedString.Key.foregroundColor: UIColor.label
//        ]
//        
//        let width = numStr.boundingRect(
//            with: CGSize.init( width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
//            options: NSStringDrawingOptions(rawValue: 0),
//            attributes: attribute,
//            context: nil
//        ).size.width
//        
//        numStr.draw(
//            in: CGRect.init(
//                x: 0-width/2,
//                y: 10.0, //longLineY+10
//                width: width,
//                height: 14.0
//            ),
//            withAttributes: attribute
//        )
        let context = UIGraphicsGetCurrentContext()
        context?.addEllipse(in: CGRect(x: 0.0, y: centerY - bigCircleRaidus / 2 , width: bigCircleRaidus, height: bigCircleRaidus))
        context?.strokePath()

        let path = UIBezierPath()
        path.move(to: CGPoint.init(x: 10.0, y: centerY))
        path.addLine(to: CGPoint(x: rect.size.width + 200, y: centerY))
        UIColor.label.setStroke()
        path.lineWidth = 0.5
        path.stroke()
    }
}
