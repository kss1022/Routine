//
//  TimerHomeViewController.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs
import UIKit

protocol TimerHomePresentableListener: AnyObject {
    func creatTimerBarButtonDidTap()
    func startTimerButtonDidTap()
    func currentTimerButtonDidTap()
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
    
    
    private lazy var startTimerButton: TimerStartButton = {
        let button = TimerStartButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startTimerButtonTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var currentTimerButton: UIButton = {
        let button = TouchesRoundButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(currentTimerButtonTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var timerRullerView: UIView = {
        //0.2 * 5 = 1.0
        var rullerView = ScrollRuller(
            minValue: 0,
            maxValue: 20,
            step: 0.3,
            num: 5
        )
        rullerView.translatesAutoresizingMaskIntoConstraints = false
        rullerView.delegate      = self
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
        title = "Timer"
        tabBarItem = UITabBarItem(
            title: "Timer",
            image: UIImage(systemName: "stopwatch"),
            selectedImage: UIImage(systemName: "stopwatch.fill")
        )
        
        navigationItem.rightBarButtonItems = [ createTimerBarButtonItem]
        
        view.backgroundColor = .systemBackground
        
        
        view.addSubview(startTimerButton)
        view.addSubview(currentTimerButton)
        view.addSubview(timerRullerView)
        
        NSLayoutConstraint.activate([
            startTimerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            startTimerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startTimerButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            startTimerButton.heightAnchor.constraint(equalTo: startTimerButton.widthAnchor),
            
            currentTimerButton.topAnchor.constraint(equalTo: startTimerButton.bottomAnchor, constant: 24.0),
            currentTimerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            timerRullerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            timerRullerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            timerRullerView.heightAnchor.constraint(equalToConstant: 70.0),
            timerRullerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24.0)
        ])
    }
    
    // MARK: Presentable
    func setTimer(name: String, time: String) {
        startTimerButton.setTime(time: time)
        currentTimerButton.setTitle(name, for: .normal)
    }
    
    
    @objc
    private func createTimerBarButtonTap(){
        listener?.creatTimerBarButtonDidTap()
    }
    
    
    @objc
    private func startTimerButtonTap(){
        listener?.startTimerButtonDidTap()
    }
    
    @objc
    private func currentTimerButtonTap(){
        listener?.currentTimerButtonDidTap()
    }
    
    
}



extension TimerHomeViewController :ScrollRullerDelegate {
    func dyScrollRulerViewValueChange(rulerView: ScrollRuller, value: CGFloat) {
        Log.v("ScrollRuller :\(value)")
    }
}
