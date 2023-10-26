//
//  TimerRemainViewController.swift
//  Routine
//
//  Created by 한현규 on 10/24/23.
//

import ModernRIBs
import UIKit

protocol TimerRemainPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class TimerRemainViewController: UIViewController, TimerRemainPresentable, TimerRemainViewControllable {

    weak var listener: TimerRemainPresentableListener?
    

    
    private let timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let timeTitleLabel: UILabel = {
        let label = UILabel()
        label.setBoldFont(style: .body)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .label
        label.text = "Time Remaining"
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.setFont(style: .subheadline)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .label
        label.text = "00:00"
        return label
    }()
    
    private let cycleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let cycleTitleLabel: UILabel = {
        let label = UILabel()
        label.setBoldFont(style: .footnote)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .label
        label.text = "Cycle"
        
        return label
    }()
    
    private let cycleLabel: UILabel = {
        let label = UILabel()
        label.setFont(style: .caption1)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .label
        
        return label
    }()
    
    
    private let roundStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let roundTitleLabel: UILabel = {
        let label = UILabel()
        label.setBoldFont(style: .footnote)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .label
        label.text = "Round"
        
        return label
    }()
    
    private let roundLabel: UILabel = {
        let label = UILabel()
        label.setFont(style: .caption1)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .label
        label.text = "3/4"
        return label
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
        
        
                
        view.addSubview(cycleStackView)
        view.addSubview(timeStackView)
        view.addSubview(roundStackView)
                
        timeStackView.addArrangedSubview(timeTitleLabel)
        timeStackView.addArrangedSubview(timeLabel)
                
        cycleStackView.addArrangedSubview(cycleTitleLabel)
        cycleStackView.addArrangedSubview(cycleLabel)
        
        roundStackView.addArrangedSubview(roundTitleLabel)
        roundStackView.addArrangedSubview(roundLabel)
        
        
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            timeStackView.topAnchor.constraint(equalTo: view.topAnchor),
            timeStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
            cycleStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            cycleStackView.trailingAnchor.constraint(equalTo: timeStackView.leadingAnchor, constant: -inset),
            cycleStackView.bottomAnchor.constraint(equalTo: timeStackView.bottomAnchor),
                        
            roundStackView.leadingAnchor.constraint(equalTo: timeStackView.trailingAnchor, constant: inset),
            roundStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            roundStackView.bottomAnchor.constraint(equalTo: timeStackView.bottomAnchor),
        ])
    }
    
    
    //MARK: Presentable
    func showCycleView() {
        cycleStackView.isHidden = false
    }
    
    func hideCycleView() {
        cycleStackView.isHidden = true
    }
    
    func setTime(time: String){
        timeLabel.text = time
    }
    
    
    func setCycle(cycle: String){
        cycleLabel.text = cycle
    }
    
    func setRound(round: String){
        roundLabel.text = round
    }
    
    
}
