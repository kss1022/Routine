//
//  AppTutorialTimerViewController.swift
//  Routine
//
//  Created by 한현규 on 11/29/23.
//

import ModernRIBs
import UIKit

protocol AppTutorialTimerPresentableListener: AnyObject {
    func reminderTimePickerValueChange(date: Date)

    func allowReminderButtonDidTap()
    func notNowButtonDidTap()
}

final class AppTutorialTimerViewController: UIViewController, AppTutorialTimerPresentable, AppTutorialTimerViewControllable {
    
    weak var listener: AppTutorialTimerPresentableListener?
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 16.0
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .getBoldFont(size: 48.0)
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .getFont(size: 24.0)
        label.textColor = .white
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var timePikcer: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.date = Date()
        datePicker.addTarget(self, action: #selector(timePickerValueChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 8.0
        return stackView
    }()
    
    private lazy var allowReminderButton: TouchesRoundButton = {
        let button = TouchesRoundButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .getFont(size: 24.0)
        button.setTitle("Allow Reminder", for: .normal)
        
        
        button.contentEdgeInsets = .init(top: 16.0, left: 32.0, bottom: 16.0, right: 32.0)
        button.addTarget(self, action: #selector(allowReminderButtonTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var notNowButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .getFont(size: 15.0)
        button.setTitle("Not Now", for: .normal)
        
        button.addTarget(self, action: #selector(notNowButtonTap), for: .touchUpInside)
        return button
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
        view.backgroundColor = .primaryColor
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(labelStackView)
        stackView.addArrangedSubview(timePikcer)
        stackView.addArrangedSubview(buttonStackView)
        
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(subTitleLabel)
        
        buttonStackView.addArrangedSubview(allowReminderButton)
        buttonStackView.addArrangedSubview(notNowButton)
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: inset),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -inset),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -inset)
        ])
        
        titleLabel.text = "For you who can forget your routine"
        subTitleLabel.text = "Allow an alarm so that the routine can send you a notification."
    }
    
    @objc
    private func timePickerValueChanged(_ sender: UIDatePicker){
        self.listener?.reminderTimePickerValueChange(date: sender.date)
    }
    
    @objc
    private func allowReminderButtonTap(){
        listener?.allowReminderButtonDidTap()
    }
    
    @objc
    private func notNowButtonTap(){
        listener?.notNowButtonDidTap()
    }
}

