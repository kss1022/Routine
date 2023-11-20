//
//  GressHeaderView.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import UIKit


final class GressHeaderView: UIScrollView{
    
    private let gressCalender = GressCalender()
    
    private var labels = [UILabel]()
    private var labelsLeadingLayoutConstraint = [NSLayoutConstraint]()
    private let offSet: CGFloat = 10.0 + 2.0 //itemSize+ spacing
    
    private func label() -> UILabel{
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .getBoldFont(size: 8.0)
        label.textColor =  .label
        return label
    }
    
    init(){
        super.init(frame: .zero)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setView()
    }
    
    private func setView(){
        self.labels = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct", "Nov", "Dec"].map { week in
            let label = label()

            label.text = week
            return label
        }
        
        labels.forEach { addSubview($0) }
        
        self.labelsLeadingLayoutConstraint = labels.map {
            $0.topAnchor.constraint(equalTo: topAnchor).isActive = true
            $0.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            let leadingConstraint = $0.leadingAnchor.constraint(equalTo: leadingAnchor)
            leadingConstraint.isActive = true
            return leadingConstraint
        }                
    }
    
    
    func setLabelsConstraint(year: Int){
        guard let firstDayOfYear = gressCalender.firstDayToWeekDay(year: year) else { return }
        
        //self.labelsLeadingLayoutConstraint
        
        for offset in 1...11{
            let constraint = labelsLeadingLayoutConstraint[offset]
            let yearOfDay = gressCalender.dayOfYear(year: year, month: offset + 1)!
            
            let firstReactPosition = yearOfDay + firstDayOfYear
            
            var rowPosition = CGFloat(firstReactPosition / 7)
            if (firstReactPosition % 7) > 3{
                rowPosition += 1
            }
            
            constraint.constant = rowPosition * offSet
        }
    }
}
