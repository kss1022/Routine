//
//  RepeatMontlyControl.swift
//  Routine
//
//  Created by 한현규 on 10/9/23.
//

import Foundation
import FSCalendar


final class RepeatMontlyControl: UIControl{
    
    public var days : [Int: Bool]
    
    private var dragedButton: UIButton?
    
    private let monthlyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8.0
        return stackView
    }()
    
    private func weeklyStackView() -> UIStackView{
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 16.0
        return stackView
    }
    
    private func dateButton() -> UIButton{
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .regular)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .clear
                                
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true                
        
        button.addTarget(self, action: #selector(dateButtonTap), for: .touchUpInside)
        return button
    }
    
    private lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitleColor(.systemBlue, for: .normal)
        button.setFont(style: .caption2)
        
        button.setTitle("Reset", for: .normal)
        button.addTarget(self, action: #selector(resetButtonTap), for: .touchUpInside)
        return button
    }()
    
    init(){
        self.days = .init()
        super.init(frame: .zero)
        
        setLayout()
    }
            
    required init?(coder: NSCoder) {
        self.days = .init()
        super.init(coder: coder)
        
        setLayout()
    }
    
    
    
    private func setLayout(){
        self.addSubview(monthlyStackView)
        self.addSubview(resetButton)
        
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanWith(gestureRecognizer:)))        
        self.addGestureRecognizer(panGestureRecognizer)

        
        NSLayoutConstraint.activate([
            monthlyStackView.topAnchor.constraint(equalTo: self.topAnchor),
            monthlyStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            monthlyStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            monthlyStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            resetButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            resetButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        
        var weeklyStackView: UIStackView!
        
        [[1, 2, 3, 4, 5, 6, 7], [8, 9, 10, 11, 12, 13, 14], [15, 16, 17, 18, 19, 20, 21], [22, 23, 24, 25, 26, 27, 28], [29, 30, 31] ].forEach { array in
            weeklyStackView = self.weeklyStackView()
            monthlyStackView.addArrangedSubview(weeklyStackView)
            array.forEach {  date in
                let button = dateButton()
                button.tag = date
                button.setTitle("\(date)", for: .normal)
                weeklyStackView.addArrangedSubview(button)
            }
        }
                        
        for _ in 0..<4{
            weeklyStackView.addArrangedSubview(UIView())
        }

    }
    
    
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let height = ( monthlyStackView.frame.height - (monthlyStackView.spacing * 4) ) / 5
        
        monthlyStackView.arrangedSubviews.forEach {
            if let weeklyStackView = $0 as? UIStackView{
                weeklyStackView.arrangedSubviews.forEach {
                    $0.roundCorners()
                    $0.roundCorners(height / 2)
                }
            }
        }
    }
    

  
    
    @objc
    private func dateButtonTap(sender : UIButton){
        let tag = sender.tag
                
        let isSelected = !( self.days[tag] ?? false )
        
        if isSelected{
            self.days[tag] = isSelected
        }else{
            self.days[tag]  = nil
        }

        if isSelected{
            sender.setTitleColor(.white, for: .normal)
            sender.backgroundColor = .primaryColor
        }else{
            sender.setTitleColor(.label, for: .normal)
            sender.backgroundColor = .clear
        }
                
        self.sendActions(for: .valueChanged)
        
    }
    
    
   
    @objc
    private func resetButtonTap(){
        self.days.forEach { (key, value) in
            let index = (key - 1)
            
            let monthlyIndex = index / 7
            let dayIndex = index % 7
            
            if let weeklyStackView =  monthlyStackView.arrangedSubviews[safe: monthlyIndex] as? UIStackView{
                if let dayButton = weeklyStackView.arrangedSubviews[safe: dayIndex] as? UIButton{
                    unselectButton(sender: dayButton)
                }
            }
        }
        
        self.sendActions(for: .valueChanged)
    }
    
}


extension RepeatMontlyControl{
    
        
    @objc 
    private func didPanWith(gestureRecognizer: UIPanGestureRecognizer) {
        let point = gestureRecognizer.location(in: self)

        let draggedView = self.hitTest(point, with: nil)

        
        guard let dateButton = draggedView as? UIButton else { return }
        if dateButton == dragedButton{ return }
        
        self.dragedButton = dateButton
        if gestureRecognizer.state == .changed{
            selectButton(sender: dateButton) //sendActions
        }else if  gestureRecognizer.state.rawValue > UIGestureRecognizer.State.changed.rawValue{
            dragedButton = nil
            self.sendActions(for: .valueChanged)
        }
    }

    
    // sendActions in this function
    private func selectButton(sender : UIButton){
        let tag = sender.tag
        
        if tag == 0{
            return
        }
                
        if  (self.days[tag] ?? false){
            //button is already selected
            return
        }
        
        self.days[tag] = true
        sender.setTitleColor(.white, for: .normal)
        sender.backgroundColor = .primaryColor
        self.sendActions(for: .valueChanged)
    }
    
    // for reset button
    private func unselectButton(sender : UIButton){
        let tag = sender.tag
                
        
        if  !(self.days[tag] ?? false){
            //button is already unselected
            return
        }
        
        
        self.days[tag] = nil
        sender.setTitleColor(.label, for: .normal)
        sender.backgroundColor = .clear
    }
}
