//
//  RepeatWeeklyControl.swift
//  Routine
//
//  Created by 한현규 on 10/9/23.
//

import UIKit



final class RepeatWeeklyControl: UIControl{
    
    public var weeklys = Repeatweeklys()
        
    private var dragedButton: UIButton? //For PagGesture
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 16.0
        return stackView
    }()
    
    private func weeklyButton() -> UIButton{
        let button = RoutineRepeatControlButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .getFont(size: 12.0)
        button.addTarget(self, action: #selector(weeklyButtonTap), for: .touchUpInside)
        return button
    }
    
    
    init() {
        super.init(frame: .zero)
                
        setView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
                
        setView()
    }
    
    private func setView(){
        self.addSubview(stackView)
        // TODO: LongPress로 변경?
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanWith(gestureRecognizer:)))
        self.addGestureRecognizer(panGestureRecognizer)
                
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        
        self.weeklys.routineWeeklys.map{ $0.weekly.veryShortWeekydaySymbols() }
            .enumerated().forEach { (index, weekly) in
            let button = weeklyButton()
            button.setTitle(weekly, for: .normal)
            button.tag = index
            stackView.addArrangedSubview(button)
        }

    }
    
    
    func setWeeklys(weeklys: Set<WeeklyViewModel>){
        weeklys.forEach { weekly in
            self.weeklys.routineWeeklys[weekly.rawValue].isSelected = true
            
            if let button = stackView.arrangedSubviews[safe: weekly.rawValue] as? RoutineRepeatControlButton{
                button.isSelected = true
                //button.updateLayer()
            }
        }
    }
    
    
    
    @objc
    private func weeklyButtonTap(sender : UIButton){
        let tag = sender.tag
                                    
        let isSelected = !self.weeklys.routineWeeklys[tag].isSelected
        self.weeklys.routineWeeklys[tag].isSelected = isSelected
        
        sender.isSelected = isSelected
        self.sendActions(for: .valueChanged)
    }
    
    
}


extension RepeatWeeklyControl{
    
    
    @objc
    private func didPanWith(gestureRecognizer: UIPanGestureRecognizer) {
        let point = gestureRecognizer.location(in: self)
        
        let draggedView = self.hitTest(point, with: nil)
        
        
        guard let dateButton = draggedView as? UIButton else { return }
        if dateButton == dragedButton{ return }
        
        self.dragedButton = dateButton
        if gestureRecognizer.state == .changed{
            weeklyButtonTap(sender: dateButton) //sendActions
        }else if  gestureRecognizer.state.rawValue > UIGestureRecognizer.State.changed.rawValue{
            dragedButton = nil
            self.sendActions(for: .valueChanged)
        }
    }
    
}



internal struct Repeatweeklys{
    
    var routineWeeklys: [Repeatweekly]
        
    init() {
        self.routineWeeklys = WeeklyViewModel.allCases.map(Repeatweekly.init)
    }

}

internal struct Repeatweekly{
    
    let weekly: WeeklyViewModel
    var isSelected: Bool
    
    init(weekly: WeeklyViewModel) {
        self.weekly = weekly
        self.isSelected = false
    }
        
    
}



