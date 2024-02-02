//
//  TabataProgressViewController.swift
//  Routine
//
//  Created by 한현규 on 1/17/24.
//

import ModernRIBs
import UIKit

protocol TabataProgressPresentableListener: AnyObject {
}

final class TabataProgressViewController: UIViewController, TabataProgressPresentable, TabataProgressViewControllable {

    weak var listener: TabataProgressPresentableListener?
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.spacing = 32.0
        return stackView
    }()
    
    private let timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let countStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 16.0
        return stackView
    }()
    
    private let timeTitleLabel: UILabel = {
        let label = UILabel()
        label.setBoldFont(style: .body)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.text = "timer_remaining".localized(tableName: "Timer")
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.setFont(style: .subheadline)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.text = "00:00"
        return label
    }()
    
    private let cycleCountInfoView: TimerCountInfoView = {
        let view = TimerCountInfoView()
        return view
    }()
    
    
    private let roundCountInfoView: TimerCountInfoView = {
        let view = TimerCountInfoView()
        return view
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
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(timeStackView)
        stackView.addArrangedSubview(countStackView)
        
        timeStackView.addArrangedSubview(timeTitleLabel)
        timeStackView.addArrangedSubview(timeLabel)
                
        countStackView.addArrangedSubview(roundCountInfoView)
        countStackView.addArrangedSubview(cycleCountInfoView)        
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        updateTransition()
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: {  [weak self] _ in
            self?.updateTransition()
        }, completion: nil)
        updateTransition()
    }
    
    private func updateTransition(){
        if !UIDevice.current.orientation.isLandscape{
            stackView.axis = .horizontal
            stackView.alignment = .center
        }else{
            stackView.axis = .vertical
            stackView.alignment = .center
        }
    }
    
    //MARK: Presentable
    func setTime(time: String) {
        timeLabel.text = time
    }
            
    func setCycleInfoView(viewModel: TimerCountInfoViewModel) {
        cycleCountInfoView.setCountInfo(viewModel)
    }
    
    func setRoundInfoView(viewModel: TimerCountInfoViewModel) {
        roundCountInfoView.setCountInfo(viewModel)
    }
    
}
