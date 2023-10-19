//
//  CircularTimerViewController.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import ModernRIBs
import UIKit

protocol CircularTimerPresentableListener: AnyObject {
    func activeButtonDidTap()
    func cancelButtonDidTap()
}

final class CircularTimerViewController: UIViewController, CircularTimerPresentable, CircularTimerViewControllable{
    

    
    
    weak var listener: CircularTimerPresentableListener?
    
    
    private lazy var timerView: CircularTimerView = {
        let view = CircularTimerView()
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
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.backgroundColor = .systemGreen.withAlphaComponent(0.5)
        button.titleLabel?.adjustsFontSizeToFitWidth = true

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
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancle", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGray.withAlphaComponent(0.5)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        
        button.contentEdgeInsets = .init(
            top: 8.0,
            left: 8.0,
            bottom: 8.0,
            right: 8.0
        )
        
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
        
        
        NSLayoutConstraint.activate([
            timerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            timerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            timerView.heightAnchor.constraint(equalTo: timerView.widthAnchor),
            
            buttonStackView.topAnchor.constraint(equalTo: timerView.bottomAnchor, constant: -16.0),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 16.0),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            
            cancelButton.widthAnchor.constraint(equalToConstant: 60.0),
            cancelButton.heightAnchor.constraint(equalToConstant: 60.0),
            activeButton.widthAnchor.constraint(equalToConstant: 60.0),
            activeButton.heightAnchor.constraint(equalToConstant: 60.0),
        ])
        
        cancelButton.roundCorners(30.0)
        activeButton.roundCorners(30.0)
    }
    
    // MARK: Presentable
    func showStartButton() {
        
    }
    
    func showPauseButton() {
        
    }
    
    func showResumeButton() {
        
    }
    
    func setTimer(_ viewModel: CircularTimerViewModel) {
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
