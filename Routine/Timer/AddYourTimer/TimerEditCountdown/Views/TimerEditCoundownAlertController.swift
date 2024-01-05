//
//  TimerEditCoundownAlertController.swift
//  Routine
//
//  Created by 한현규 on 11/1/23.
//

import UIKit



protocol TimerEditCoundownAlertControllerDelegate: AnyObject{
    func timerEditCoundownAlertController(hour: Int, min: Int)
}

final class TimerEditCoundownAlertController: UIViewController{
    
    
    weak var delegate: TimerEditCoundownAlertControllerDelegate?
    
    
    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addShadowWithRoundedCorners()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    
    private let navigationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill")?.setSize(pointSize: 14.0), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(cancelButtonTap), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .getFont(size: 14.0)
        label.textColor = .label
        label.text = "set_duration".localized(tableName: "Timer")
        return label
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("done".localized(tableName: "Timer"), for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(doneButtonTap), for: .touchUpInside)
        return button
    }()
    
    
    
    private let pickerView: TimerEditCountdownPickerView = {
        let pickerView = TimerEditCountdownPickerView()
        return pickerView
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
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
        view.backgroundColor =  UIColor.black.withAlphaComponent(0.50)
        
        view.addSubview(cardView)
        cardView.addSubview(stackView)
        
        stackView.addArrangedSubview(navigationStackView)
        stackView.addArrangedSubview(pickerView)
        
        navigationStackView.addArrangedSubview(cancelButton)
        navigationStackView.addSubview(titleLabel)
        navigationStackView.addArrangedSubview(doneButton)
        
        NSLayoutConstraint.activate([
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            stackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8.0),
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16.0),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16.0),
            stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -8.0),
            
            titleLabel.centerXAnchor.constraint(equalTo: navigationStackView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: navigationStackView.centerYAnchor),
        ])
        
    }
    
    func setCountdown(hour: Int, min: Int){
        pickerView.setCountdown(hour: hour, min: min)
    }
    
    @objc
    private func cancelButtonTap(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func doneButtonTap(){
        self.delegate?.timerEditCoundownAlertController(hour: pickerView.hour, min: pickerView.min)
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
