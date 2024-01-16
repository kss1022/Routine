//
//  TimerEditMinutesViewController.swift
//  Routine
//
//  Created by 한현규 on 1/16/24.
//

import ModernRIBs
import UIKit
import SwiftUI

protocol TimerEditMinutesPresentableListener: AnyObject {
    func timeLabelDidTap()
    func countdownAlertDoneButtonDidTap(hour: Int, min: Int)
        
    func plusButtonDidTap()
    func plusBunttonLongPressBegan()
    func plusButtonLongPressEnded()
    
    func minusButtonDidTap()
    func minusBunttonLongPressBegan()
    func minusButtonLongPressEnded()
}

final class TimerEditMinutesViewController: UIViewController, TimerEditMinutesPresentable, TimerEditMinutesViewControllable {

    weak var listener: TimerEditMinutesPresentableListener?
    
    
    private let cardView: UIView = {
        let cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .black
        cardView.addShadowWithRoundedCorners()
        return cardView
    }()
    
    private let stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    

    private let focusTime = SUI_TimerEditCountdownLabelViewModel()
    private lazy var timerTimeLabel: UIView = {
        let suiLabel = SUI_TimerEditCountdownLabel()
        
        let view = UIHostingController(rootView: suiLabel.environmentObject(focusTime)).view!
        view.backgroundColor = .clear
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(timeLabelTap))
        view.addGestureRecognizer(singleTapGesture)
        return view
    }()
        
    private lazy var plusButton : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image: UIImage(systemName: "plus.circle.fill"), state: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(plusButtonTap), for: .touchUpInside)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(plusButtonLongPress(gesture:)))
        longPress.minimumPressDuration = 0.5
        button.addGestureRecognizer(longPress)
        
        return button
    }()
    
    private lazy var minusButton : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image: UIImage(systemName: "minus.circle.fill"), state: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(minusButtonTap), for: .touchUpInside)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(minusButtonLongPress(gesture:)))
        longPress.minimumPressDuration = 0.5
        button.addGestureRecognizer(longPress)
        
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
        view.addSubview(cardView)
        
        cardView.addSubview(stackView)
        
        stackView.addArrangedSubview(minusButton)
        stackView.addArrangedSubview(timerTimeLabel)
        stackView.addArrangedSubview(plusButton)
                                
        let inset: CGFloat = 8.0
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: view.topAnchor, constant: inset),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset),
            
            
            stackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 36.0),
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16.0),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16.0),
            stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -36.0),

                        
            plusButton.widthAnchor.constraint(equalTo: plusButton.heightAnchor, multiplier: 0.7),
            minusButton.widthAnchor.constraint(equalTo: minusButton.heightAnchor, multiplier: 0.7),
        ])
    }
    
    //MARK: Presentable
    func setTimes(hour: Int,  minute: Int) {
        self.focusTime.hour = hour
        self.focusTime.minute = minute
    }
    
    func showTimePickerAlert(hour:Int, minute: Int) {
        let countdownAlert = TimerEditCoundownAlertController()
        countdownAlert.delegate = self
        countdownAlert.setCountdown(hour: hour, min: minute)
        self.present(countdownAlert, animated: true)
    }
    
    
    @objc
    private func timeLabelTap(){
        listener?.timeLabelDidTap()
    }
    
    @objc
    private func plusButtonTap(){
        listener?.plusButtonDidTap()
    }
    
    @objc
    private func plusButtonLongPress(gesture: UILongPressGestureRecognizer){
        if gesture.state == .began{
            listener?.plusBunttonLongPressBegan()
        }else if gesture.state == .ended{
            listener?.plusButtonLongPressEnded()
        }
    }
    
    @objc
    private func minusButtonTap(){
        listener?.minusButtonDidTap()
    }

    
    @objc
    private func minusButtonLongPress(gesture: UILongPressGestureRecognizer){
        if gesture.state == .began{
            listener?.minusBunttonLongPressBegan()
        }else if gesture.state == .ended{
            listener?.minusButtonLongPressEnded()
        }
    }


}



extension TimerEditMinutesViewController: TimerEditCoundownAlertControllerDelegate{
    func timerEditCoundownAlertController(hour: Int, min: Int) {
        listener?.countdownAlertDoneButtonDidTap(hour: hour, min: min)
    }        
}
