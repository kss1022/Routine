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

    
    private let buttonTitleColor = UIColor.label
    private let buttonBackgroundColor = UIColor.systemBackground
    
    private let buttonSelectedTitleColor = UIColor.white
    private let buttonSelectedBackgroundColor = UIColor.primaryColor
    
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 16.0
        return stackView
    }()
    
    private func weeklyButton() -> UIButton{
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .regular)
        button.setTitleColor(self.buttonTitleColor, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = self.buttonBackgroundColor
        
        
        button.addTarget(self, action: #selector(weeklyButtonTap), for: .touchUpInside)
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        
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
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        

        weeklys.routineWeeklys.enumerated().forEach { (index, weekly) in
            let button = weeklyButton()
            
            let rawValue = weekly.weekly.rawValue.prefix(1).map(String.init).first!
            button.setTitle(rawValue, for: .normal)
            button.tag = index
            stackView.addArrangedSubview(button)
        }

    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let height = stackView.frame.height
        
        stackView.arrangedSubviews.forEach {
            $0.roundCorners(height / 2)
        }
    }
    
    
    @objc
    private func weeklyButtonTap(sender : UIButton){
        let tag = sender.tag
                                    
        let isSelected = !self.weeklys.routineWeeklys[tag].isSelected
        self.weeklys.routineWeeklys[tag].isSelected = isSelected
        
        if isSelected{
            sender.setTitleColor(self.buttonSelectedTitleColor, for: .normal)
            sender.backgroundColor = self.buttonSelectedBackgroundColor
        }else{
            sender.setTitleColor(self.buttonTitleColor, for: .normal)
            sender.backgroundColor = self.buttonBackgroundColor
        }
                        
        self.sendActions(for: .valueChanged)
        
    }
    
    
}




internal struct Repeatweeklys{
    
    var routineWeeklys: [Repeatweekly]
        
    init() {
        self.routineWeeklys = Weekly.allCases.map(Repeatweekly.init)
    }

}

internal struct Repeatweekly{
    
    let weekly: Weekly
    var isSelected: Bool
    
    init(weekly: Weekly) {
        self.weekly = weekly
        self.isSelected = false
    }
    
}

