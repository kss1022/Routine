//
//  SectionRoundTimerViewController.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import ModernRIBs
import UIKit

protocol SectionRoundTimerPresentableListener: AnyObject {
    func activeButtonDidTap()
    func cancelButtonDidTap()
}

final class SectionRoundTimerViewController: UIViewController, SectionRoundTimerPresentable, SectionRoundTimerViewControllable{
    

    
    
    weak var listener: SectionRoundTimerPresentableListener?
    
    
    private var timerViewWidthConstraint: NSLayoutConstraint?
    private var timerViewHeightConstraint: NSLayoutConstraint?
    private var buttonStackViewWidhConstraint: NSLayoutConstraint?
    
    private let timerView: RoundTimerView = {
        let view = RoundTimerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        
        button.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .bold)
        
        button.contentEdgeInsets = .init(
            top: 8.0,
            left: 8.0,
            bottom: 8.0,
            right: 8.0
        )
        
        button.addTarget(self, action: #selector(activeButtonTap), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = TouchesRoundButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .bold)

        button.setTitleColor(.white, for: .normal)
        
        button.contentEdgeInsets = .init(
            top: 8.0,
            left: 8.0,
            bottom: 8.0,
            right: 8.0
        )
        
        button.setTitle("Cancle", for: .normal)
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
        view.backgroundColor = .systemBackground
                
        
        view.addSubview(timerView)
        view.addSubview(buttonStackView)
        
            
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(activeButton)
                
        let inset: CGFloat = 16.0
        
                
        NSLayoutConstraint.activate([
            timerView.topAnchor.constraint(equalTo: view.topAnchor),
            timerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonStackView.topAnchor.constraint(equalTo: timerView.bottomAnchor, constant: -inset),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: inset),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            buttonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            buttonStackView.heightAnchor.constraint(equalToConstant: 80.0),
            
            cancelButton.widthAnchor.constraint(equalToConstant: 80.0),
            activeButton.widthAnchor.constraint(equalToConstant: 80.0),
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
        
        if UIDevice.current.orientation.isLandscape{
            timerWidth = bounds.width * 0.5
            stackViewWidth = timerWidth + 32.0
        }
                        
        
        if let timerViewWidth = timerViewWidthConstraint,
           let timerViewHeight = timerViewHeightConstraint,
           let buttonStackViewWidhConstraint = buttonStackViewWidhConstraint
        {
            timerViewWidth.constant = timerWidth
            timerViewHeight.constant = timerWidth
            buttonStackViewWidhConstraint.constant = stackViewWidth
        }else{
            timerViewWidthConstraint = timerView.widthAnchor.constraint(equalToConstant: timerWidth)
            timerViewHeightConstraint = timerView.heightAnchor.constraint(equalToConstant: timerWidth)
            buttonStackViewWidhConstraint = buttonStackView.widthAnchor.constraint(equalToConstant: stackViewWidth)
            
            timerViewWidthConstraint!.isActive = true
            timerViewHeightConstraint!.isActive = true
            buttonStackViewWidhConstraint!.isActive = true
        }
    }
    
        
    
    // MARK: Presentable
    func showStartButton() {
        activeButton.setTitle("Start", for: .normal)
        activeButton.setTitleColor(.systemGreen, for: .normal)
        activeButton.backgroundColor = .systemGreen.withAlphaComponent(0.5)
    }
    
    func showPauseButton() {
        activeButton.setTitle("Pause", for: .normal)
        activeButton.setTitleColor(.systemOrange, for: .normal)
        activeButton.backgroundColor = .systemOrange.withAlphaComponent(0.5)
    }
    
    func showResumeButton() {
        activeButton.setTitle("Resume", for: .normal)
        activeButton.setTitleColor(.systemGreen, for: .normal)
        activeButton.backgroundColor = .systemGreen.withAlphaComponent(0.5)
    }
    
    func setTimer(_ viewModel: RoundTimerViewModel) {
        timerView.bindView(viewModel)
    }
    
    
    func updateRemainTime(time: String) {
        timerView.setTimeLabel(time: time)
    }
    
    func startProgress(totalDuration: TimeInterval) {
        timerView.startProgress(duration: totalDuration)
    }
    
    func updateProgress(from: CGFloat, remainDuration: TimeInterval) {
        timerView.updateProgress(from: from, remainDuration: remainDuration)
    }
        
    func resumeProgress() {
        timerView.resumeProgress()
    }
    
    func suspendProgress(){
        timerView.suspendProgress()
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
