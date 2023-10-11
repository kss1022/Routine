//
//  RepeatWeeklyControl.swift
//  Routine
//
//  Created by 한현규 on 10/9/23.
//

import UIKit

// TODO: Button의 selected원을 보여줄떄 작아졋다 커지는 애니메이션을 해준다.
// FSCalender 와 같이 circle을 직접 그려준다. 
// font와 관계없이 그려주는게 좋을 듯함! -> 중앙을 찍고 원을 그려버린다.

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
        button.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .regular)
        button.addTarget(self, action: #selector(weeklyButtonTap), for: .touchUpInside)
        return button
    };
    
    
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
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanWith(gestureRecognizer:)))
        self.addGestureRecognizer(panGestureRecognizer)
                
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        

        
        self.weeklys.routineWeeklys.map{ "\($0.weekly.label().first!)" }
            .enumerated().forEach { (index, weekly) in
            let button = weeklyButton()
            button.setTitle(weekly, for: .normal)
            button.tag = index
            stackView.addArrangedSubview(button)
        }

    }
    
    
    func setWeeklys(weeklys: Set<WeekliyViewModel>){
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
        self.routineWeeklys = WeekliyViewModel.allCases.map(Repeatweekly.init)
    }

}

internal struct Repeatweekly{
    
    let weekly: WeekliyViewModel
    var isSelected: Bool
    
    init(weekly: WeekliyViewModel) {
        self.weekly = weekly
        self.isSelected = false
    }
        
    
}



