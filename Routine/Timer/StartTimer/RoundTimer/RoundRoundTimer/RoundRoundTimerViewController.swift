//
//  RoundRoundTimerViewController.swift
//  Routine
//
//  Created by 한현규 on 1/18/24.
//

import ModernRIBs
import UIKit

protocol RoundRoundTimerPresentableListener: AnyObject {
    func activeButtonDidTap()
    func cancelButtonDidTap()
}

final class RoundRoundTimerViewController: UIViewController, RoundRoundTimerPresentable, RoundRoundTimerViewControllable {

    weak var listener: RoundRoundTimerPresentableListener?
    
    private var timerViewWidthConstraint: NSLayoutConstraint?
    private var timerViewHeightConstraint: NSLayoutConstraint?
    private var buttonStackViewWidhConstraint: NSLayoutConstraint?
    
    private var cancelButtonWidthConstraint: NSLayoutConstraint?
    private var activeButtonWidthConstraint: NSLayoutConstraint?
    
    private let roundTimerView: RoundRoundTimerView = {
        let roundTimerView = RoundRoundTimerView()
        roundTimerView.translatesAutoresizingMaskIntoConstraints = false
        return roundTimerView
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var activeButton: UIButton = {
        let button = TouchesRoundButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .getBoldFont(size: 16.0)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.contentEdgeInsets = .init(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        
        button.addTarget(self, action: #selector(activeButtonTap), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = TouchesRoundButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .getBoldFont(size: 16.0)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(.white, for: .normal)
        button.contentEdgeInsets = .init(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        
        button.setTitle("cancel".localized(tableName: "Timer"), for: .normal)
        button.backgroundColor = UIColor(hex: "#5B5B5BFF")
        
        button.addTarget(self, action: #selector(cancelButtonTap), for: .touchUpInside)
        
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
        title = "Timer"
        
        view.addSubview(roundTimerView)
        view.addSubview(buttonStackView)
        
        
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(activeButton)
        
        let inset: CGFloat = 16.0
        
        
        NSLayoutConstraint.activate([
            roundTimerView.topAnchor.constraint(equalTo: view.topAnchor),
            roundTimerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonStackView.topAnchor.constraint(equalTo: roundTimerView.bottomAnchor, constant: -inset),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: inset),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            buttonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            //cancelButton.widthAnchor.constraint(equalToConstant: 80.0),
            cancelButton.heightAnchor.constraint(equalTo: cancelButton.widthAnchor),
            
            //activeButton.widthAnchor.constraint(equalToConstant: 80.0),
            activeButton.heightAnchor.constraint(equalTo: activeButton.widthAnchor),
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
        var stackViewWidth = bounds.width - 32.0
        var buttoWidth = 80.0
        
        
        if UIDevice.current.orientation.isLandscape{
            timerWidth = bounds.width * 0.5
            stackViewWidth = timerWidth + 32.0
            buttoWidth = 60.0
        }
        
        
        if let timerViewWidth = timerViewWidthConstraint,
           let timerViewHeight = timerViewHeightConstraint,
           let buttonStackViewWidhConstraint = buttonStackViewWidhConstraint,
           let cancelButtonWidthConstraint = cancelButtonWidthConstraint,
           let activeButtonWidthConstraint = activeButtonWidthConstraint
        {
            timerViewWidth.constant = timerWidth
            timerViewHeight.constant = timerWidth
            buttonStackViewWidhConstraint.constant = stackViewWidth
            cancelButtonWidthConstraint.constant = buttoWidth
            activeButtonWidthConstraint.constant = buttoWidth
        }else{
            timerViewWidthConstraint = roundTimerView.widthAnchor.constraint(equalToConstant: timerWidth)
            timerViewHeightConstraint = roundTimerView.heightAnchor.constraint(equalToConstant: timerWidth)
            buttonStackViewWidhConstraint = buttonStackView.widthAnchor.constraint(equalToConstant: stackViewWidth)
            cancelButtonWidthConstraint = cancelButton.widthAnchor.constraint(equalToConstant: buttoWidth)
            activeButtonWidthConstraint = activeButton.widthAnchor.constraint(equalToConstant: buttoWidth)
            
            timerViewWidthConstraint!.isActive = true
            timerViewHeightConstraint!.isActive = true
            buttonStackViewWidhConstraint!.isActive = true
            cancelButtonWidthConstraint!.isActive = true
            activeButtonWidthConstraint!.isActive = true
        }
    }
    
    
    
    // MARK: Presentable
    func showStartButton() {
        activeButton.setTitle("start".localized(tableName: "Timer"), for: .normal)
        activeButton.setTitleColor(.systemGreen, for: .normal)
        activeButton.backgroundColor = .systemGreen.withAlphaComponent(0.5)
    }
    
    func showPauseButton() {
        activeButton.setTitle("pause".localized(tableName: "Timer"), for: .normal)
        activeButton.setTitleColor(.systemOrange, for: .normal)
        activeButton.backgroundColor = .systemOrange.withAlphaComponent(0.5)
    }
    
    func showResumeButton() {
        activeButton.setTitle("resume".localized(tableName: "Timer"), for: .normal)
        activeButton.setTitleColor(.systemGreen, for: .normal)
        activeButton.backgroundColor = .systemGreen.withAlphaComponent(0.5)
    }
    
    func setTimer(_ viewModel: RoundRoundTimerViewModel) {
        roundTimerView.bindView(viewModel)
    }
    
    
    func setTime(time: String) {
        roundTimerView.setTimeLabel(time: time)
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
    private func activeButtonTap(){
        listener?.activeButtonDidTap()
    }
    
    @objc
    private func cancelButtonTap(){
        listener?.cancelButtonDidTap()
    }
    
}
