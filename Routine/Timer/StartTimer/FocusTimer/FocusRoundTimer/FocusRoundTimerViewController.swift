//
//  FocusRoundTimerViewController.swift
//  Routine
//
//  Created by 한현규 on 10/27/23.
//

import ModernRIBs
import UIKit

protocol FocusRoundTimerPresentableListener: AnyObject {
    func timerDidTap()
    func timerDidLongPress()
}

final class FocusRoundTimerViewController: UIViewController, FocusRoundTimerPresentable, FocusRoundTimerViewControllable {

    weak var listener: FocusRoundTimerPresentableListener?
    
    private var timerViewWidthConstraint: NSLayoutConstraint?
    private var timerViewHeightConstraint: NSLayoutConstraint?
        
    private lazy var roundTimerView: FocusRoundTimerView = {
        let roundTimerView = FocusRoundTimerView()
        roundTimerView.translatesAutoresizingMaskIntoConstraints = false
        roundTimerView.addTarget(self, action: #selector(roundTimerTap), for: .touchUpInside)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(roundTimerLongPress(gesture:)))
        longPress.minimumPressDuration = 0.5
        roundTimerView.addGestureRecognizer(longPress)
        
        return roundTimerView
    }()
    
  
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.font = .getBoldFont(size: 48.0)
        label.textColor = .white
        label.textAlignment = .center
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
        view.addSubview(roundTimerView)
        view.addSubview(timeLabel)
                
        NSLayoutConstraint.activate([
            roundTimerView.topAnchor.constraint(equalTo: view.topAnchor),
            roundTimerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            roundTimerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            roundTimerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            timeLabel.topAnchor.constraint(equalTo: roundTimerView.bottomAnchor, constant: 24.0),
            timeLabel.leadingAnchor.constraint(equalTo: roundTimerView.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: roundTimerView.trailingAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        updateTransition()
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.updateTransition()
        }, completion: nil)
    }
    
    
    private func updateTransition() {
        let bounds =  UIDevice.frame()
        var timerWidth = bounds.width * 0.7
        
        if UIDevice.current.orientation.isLandscape{
            timerWidth = bounds.width * 0.5
        }
        
        
        if let timerViewWidth = timerViewWidthConstraint,
           let timerViewHeight = timerViewHeightConstraint
        {
            timerViewWidth.constant = timerWidth
            timerViewHeight.constant = timerWidth
        }else{
            timerViewWidthConstraint = roundTimerView.widthAnchor.constraint(equalToConstant: timerWidth)
            timerViewHeightConstraint = roundTimerView.heightAnchor.constraint(equalToConstant: timerWidth)
                                    
            timerViewWidthConstraint!.isActive = true
            timerViewHeightConstraint!.isActive = true
        }
    }
    
   
    
    func setTimer(_ viewModel: FocusRoundTimerViewModel) {
        roundTimerView.bindView(viewModel)
        timeLabel.text = viewModel.time
    }
    
    
    func setTime(time: String) {
        //timerView.setTimeLabel(time: time)
        timeLabel.text = time
    }
    
    func startProgress(totalDuration: TimeInterval) {
        roundTimerView.startProgress(duration: totalDuration)
    }
    
    func updateProgress(from: CGFloat, remainDuration: TimeInterval) {
        roundTimerView.updateProgress(from: from, remainDuration: remainDuration)
    }
        
    func resumeProgress() {
        roundTimerView.resumeProgress()
    }
    
    func suspendProgress(){
        roundTimerView.suspendProgress()
    }


    @objc
    private func roundTimerTap(){
        listener?.timerDidTap()
    }
    
    @objc
    private func roundTimerLongPress(gesture: UILongPressGestureRecognizer){
        if gesture.state == .began {            
            listener?.timerDidLongPress()
        }
    }
    
}
