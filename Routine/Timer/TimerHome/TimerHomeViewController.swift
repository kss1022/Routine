//
//  TimerHomeViewController.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs
import UIKit

protocol TimerHomePresentableListener: AnyObject {
    func creatTimerButtonDidTap()
    func startTimerButtonDidTap()
    func selectTimerButtonDidTap()
}

final class TimerHomeViewController: UIViewController, TimerHomePresentable, TimerHomeViewControllable {
    
    
    weak var listener: TimerHomePresentableListener?
    
    private lazy var createTimerBarButtonItem : UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle"),
            style: .plain,
            target: self,
            action: #selector(createTimerBarButtonTap)
        )
        return barButtonItem
    }()
    
    
    private var startButtonVerticalConstraint: NSLayoutConstraint?
    
    private lazy var startTimerButton: TimerStartButton = {
        let button = TimerStartButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startTimerButtonTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var selectTimerButton: UIButton = {
        let button = TouchesRoundButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .label
        button.setTitleColor(.systemBackground, for: .normal)
        button.titleLabel?.font = .getBoldFont(size: 16.0)
        button.addTarget(self, action: #selector(selectTimerButtonTap), for: .touchUpInside)
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
        title = "timer".localized(tableName: "Timer")
        tabBarItem = UITabBarItem(
            title: "timer".localized(tableName: "Timer"),
            image: UIImage(systemName: "stopwatch"),
            selectedImage: UIImage(systemName: "stopwatch.fill")
        )
        
        navigationItem.rightBarButtonItems = [ createTimerBarButtonItem]
        
        view.backgroundColor = .systemBackground
        
        
        view.addSubview(startTimerButton)
        view.addSubview(selectTimerButton)        
        
        let width =  UIDevice.frame().width * 0.6
        
        
        NSLayoutConstraint.activate([
            startTimerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startTimerButton.widthAnchor.constraint(equalToConstant: width),
            startTimerButton.heightAnchor.constraint(equalTo: startTimerButton.widthAnchor),
            
            selectTimerButton.topAnchor.constraint(equalTo: startTimerButton.bottomAnchor, constant: 24.0),
            selectTimerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        updateTransition() //handle startButton Vertical Constraint
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.updateTransition()
        }, completion: nil)
    }
    
    

    private func updateTransition() {
        if let before = startButtonVerticalConstraint{
            before.isActive = false
        }
                
        if !UIDevice.current.orientation.isLandscape{
            startButtonVerticalConstraint = startTimerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        }else{
            startButtonVerticalConstraint = startTimerButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8.0)
        }
        startButtonVerticalConstraint!.isActive = true
    }
    
    
    // MARK: Presentable
    func setTimer(title: String, timerName: String) {
        startTimerButton.setTime(time: title)
        selectTimerButton.setTitle(timerName, for: .normal)
    }
    
    
    @objc
    private func createTimerBarButtonTap(){
        listener?.creatTimerButtonDidTap()
    }
    
    
    @objc
    private func startTimerButtonTap(){
        listener?.startTimerButtonDidTap()
    }
    
    @objc
    private func selectTimerButtonTap(){
        listener?.selectTimerButtonDidTap()
    }
    
    
}
