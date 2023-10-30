//
//  SetFocusTimeControl.swift
//  Routine
//  https://github.com/DanielYK/SwiftRulerView/tree/master
//  Created by 한현규 on 10/25/23.
//

import UIKit


protocol RullerViewDelegate: NSObjectProtocol {
    func rullerView(label: UILabel, secondaryLabel: UILabel,value: CGFloat)
}


extension RullerViewDelegate{
    func rullerView(label: UILabel, secondaryLabel: UILabel, value: CGFloat){
        label.text = String(format: "%.1f", value)
    }
}

class RullerView: UIView {
    
    weak var delegate:RullerViewDelegate?
    
    private let collectionViewheight: Int
    private let cellSpacing: Int
    private var cellCount: Int
        
    private var interval: CGFloat
    private var itemsPerStep: Int
    
    private var minValue: CGFloat
    private var maxValue: CGFloat

    private let cursorSize: CGFloat
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .right
        label.textColor = .systemOrange
        return label
    }()
    
    private let secondaryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .right
        label.textColor = .systemOrange
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout  = UICollectionViewFlowLayout()
        layout.scrollDirection  = UICollectionView.ScrollDirection.horizontal
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(cellType: RulerHeaderCell.self)
        collectionView.register(cellType: RullerFooterCell.self)
        collectionView.register(cellType: RullerCell.self)
        
        collectionView.delegate   = self
        collectionView.dataSource = self
        
        
        return collectionView
    }()
    
    private lazy var cursorView: RullerCursorView = {
        let cursorView = RullerCursorView()
        cursorView.translatesAutoresizingMaskIntoConstraints = false
        cursorView.backgroundColor = UIColor.clear
        cursorView.cursorSize = self.cursorSize
        return cursorView
    }()
    
    
    init(minValue: CGFloat, maxValue: CGFloat, interval: CGFloat = 1.0, itermPerStep: Int = 5) {
        self.collectionViewheight = 60
        self.cellSpacing = 10
        self.cellCount = Int( (maxValue -  minValue) / interval ) / itermPerStep
        
        self.interval =  interval
        self.itemsPerStep =  itermPerStep
        
        self.minValue =  minValue
        self.maxValue =  maxValue
        
        self.cursorSize = 12.0
        super.init(frame: .zero)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setView(){
        
        addSubview(collectionView)
        addSubview(cursorView)
        addSubview(label)
        addSubview(secondaryLabel)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: CGFloat(collectionViewheight)),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            cursorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            cursorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            cursorView.widthAnchor.constraint(equalToConstant: CGFloat(cursorSize)),
            cursorView.heightAnchor.constraint(equalToConstant: CGFloat(cursorSize)),
            
            label.bottomAnchor.constraint(equalTo: collectionView.centerYAnchor, constant: -8.0),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            secondaryLabel.topAnchor.constraint(equalTo: collectionView.centerYAnchor, constant: 8.0),
            secondaryLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    func setValue(value: CGFloat){
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.perform(#selector(self.didChangeCollectionValue), with: nil, afterDelay: 0.15)
        self.delegate?.rullerView(label: label, secondaryLabel: secondaryLabel, value: value)
    }
                      

    @objc
    private func didChangeCollectionValue() {
        guard let text = self.label.text as NSString? else { return }
        let value = CGFloat(text.floatValue)
        let totalValue = (value / interval + minValue) * CGFloat(cellSpacing)
        self.collectionView.setContentOffset(CGPoint(x: Int(totalValue), y: 0), animated: false)
    }
}



extension RullerView:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2 + cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: RulerHeaderCell.self)
            cell.backgroundColor = UIColor.clear
            cell.headerMinValue = Int(minValue)
            cell.clipsToBounds = true
            return cell
        }else if indexPath.item == cellCount+1 {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: RullerFooterCell.self)
            cell.backgroundColor = .clear
            cell.footerMaxValue = Int(maxValue)
            cell.clipsToBounds = true
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: RullerCell.self)
            cell.backgroundColor = .clear
            cell.minValue = interval*CGFloat((indexPath.item-1))*CGFloat(itemsPerStep)+minValue
            cell.maxValue = interval*CGFloat(indexPath.item)*CGFloat(itemsPerStep)
            cell.step = interval
            cell.num = itemsPerStep
            cell.rulerSpacing = CGFloat(cellSpacing)
            cell.setNeedsDisplay()
            return cell
        }
        
    }

}


//300.0 -> for bounce
extension RullerView: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 || indexPath.item == cellCount + 1 {
            return CGSize(width: Int(self.frame.size.width / 2) + 300, height: collectionViewheight)
        }
        return CGSize(width: cellSpacing * itemsPerStep, height: collectionViewheight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 0.0, left: -300.0, bottom: 0.0, right: -298.0 + CGFloat(interval)  )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let value = Int(scrollView.contentOffset.x) / cellSpacing
//        var totalValue = CGFloat(value) * interval + minValue
//
//        if totalValue >= maxValue {
//            totalValue = maxValue
//        }else if totalValue <= minValue {
//            totalValue = minValue
//        }
//        delegate?.rullerView(label: label, value: CGFloat(realPosition))
        let position = CGFloat(scrollView.contentOffset.x) / CGFloat(cellSpacing)
        let realPosition = getRealPosition(position: position)
        delegate?.rullerView(label: label, secondaryLabel: secondaryLabel, value: CGFloat(realPosition))
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        cursorView.startAnimation()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.setRealValueAndAnimated(position: CGFloat(scrollView.contentOffset.x) / CGFloat(cellSpacing), animated: true)
        }
        
        cursorView.endAnimation()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.setRealValueAndAnimated(position: CGFloat(scrollView.contentOffset.x) / CGFloat(cellSpacing), animated: true)
    }
    
    
    private func setRealValueAndAnimated(position: CGFloat, animated: Bool){
        let realPosition = getRealPosition(position: position)
        delegate?.rullerView(label: label, secondaryLabel: secondaryLabel, value: CGFloat(realPosition))
        collectionView.setContentOffset(CGPoint(x: realPosition * cellSpacing, y: 0), animated: animated) //round(realValue)
    }
    
    private func getRealPosition(position: CGFloat) -> Int{
        var realValue : CGFloat = position * interval + minValue
        
        if realValue >= maxValue {
            realValue = maxValue
        }else if realValue <= minValue {
            realValue = minValue
        }
                        
        
        var realPosition = Int(realValue)

        let rest = realPosition % 5
        let rounding = itemsPerStep / 2
        
        if rest < rounding{
            while realPosition % 5 != 0{ realPosition -= 1 }
        }else{
            while realPosition % 5 != 0{ realPosition += 1 }
        }
        return realPosition
    }
}




