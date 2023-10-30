//
//  FocusTimePickerViewController.swift
//  Routine
//
//  Created by 한현규 on 10/27/23.
//

import ModernRIBs
import UIKit

protocol FocusTimePickerPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class FocusTimePickerViewController: UIViewController, FocusTimePickerPresentable, FocusTimePickerViewControllable {

    weak var listener: FocusTimePickerPresentableListener?
    
    private lazy var rullerView: RullerView = {        
        var rullerView = RullerView(minValue: 0.0, maxValue: 240.0)
        rullerView.translatesAutoresizingMaskIntoConstraints = false
        rullerView.delegate = self
                        
        return rullerView
    }()
    
    init(){
        super.init(nibName: nil, bundle: nil)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setLayout()
    }
    
    private func setLayout(){
        view.addSubview(rullerView)
        
        view.backgroundColor = .secondarySystemBackground
        
        
        let width = UIDevice.frame().width + 32.0
        self.view.roundCorners()
        
        NSLayoutConstraint.activate([
            rullerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16.0),            
            rullerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rullerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rullerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16.0),
            rullerView.widthAnchor.constraint(equalToConstant: width)
        ])
    }
    
    func setCountdown(countdown: Int) {
        rullerView.setValue(value: CGFloat(countdown))
    }
}


extension FocusTimePickerViewController: RullerViewDelegate{
    

    
    func rullerView(label: UILabel, secondaryLabel: UILabel, value: CGFloat) {
        
        let date = Date().addingTimeInterval(TimeInterval(value * 60))
        label.text = Formatter.timeFormatter().string(from: date)
        
        let integerValue = Int(value)
        
        let hour = integerValue / 60
        let minute = integerValue % 60
        
        var time: String = ""
        
        
                
        if hour != 0{
            time += "\(hour)hour"
        }
        
        if minute != 0{
            time += "\(minute)minute"
        }

        secondaryLabel.text = time
    }
    
    
    
    
}
