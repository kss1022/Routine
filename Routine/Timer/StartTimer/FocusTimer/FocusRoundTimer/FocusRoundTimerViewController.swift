//
//  FocusRoundTimerViewController.swift
//  Routine
//
//  Created by 한현규 on 10/27/23.
//

import ModernRIBs
import UIKit

protocol FocusRoundTimerPresentableListener: AnyObject {
    func roundTimerDidTap()
    func roundTimerLongPress()
    func cancelButtonDidTap()
    func finishButtonDidTap()
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
        label.font = .systemFont(ofSize: 48.0, weight: .bold)
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
    
    // MARK: Presentable
    func showStartButton() {
//        activeButton.setTitle("Start", for: .normal)
//        activeButton.setTitleColor(.systemGreen, for: .normal)
//        activeButton.backgroundColor = .systemGreen.withAlphaComponent(0.5)
    }
    
    func showPauseButton() {
//        activeButton.setTitle("Pause", for: .normal)
//        activeButton.setTitleColor(.systemOrange, for: .normal)
//        activeButton.backgroundColor = .systemOrange.withAlphaComponent(0.5)
    }
    
    func showResumeButton() {
//        activeButton.setTitle("Resume", for: .normal)
//        activeButton.setTitleColor(.systemGreen, for: .normal)
//        activeButton.backgroundColor = .systemGreen.withAlphaComponent(0.5)
    }
    
    func showTimerActionDialog() {
        let alertController = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: UIDevice.current.userInterfaceIdiom == .pad ? .alert : .actionSheet
        )
        
        
        let cancelAction = UIAlertAction(title: "Cancel Timer", style: .default) { [weak self] _ in
            self?.listener?.cancelButtonDidTap()
        }
        
        let finishAction = UIAlertAction(title: "Finish Timer", style: .default) { [weak self] _ in
            self?.listener?.finishButtonDidTap()
        }
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel)
        
        alertController.addAction(dismissAction)
        alertController.addAction(cancelAction)
        alertController.addAction(finishAction)
        self.present(alertController, animated: true)
    }
    
    func setTimer(_ viewModel: FocusRoundTimerViewModel) {
        roundTimerView.bindView(viewModel)
        timeLabel.text = viewModel.time
    }
    
    
    func updateRemainTime(time: String) {
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
        listener?.roundTimerDidTap()
    }
    
    @objc
    private func roundTimerLongPress(gesture: UILongPressGestureRecognizer){
        if gesture.state == .began {            
            listener?.roundTimerLongPress()
        }
    }
    
    
//    @objc
//    private func activeButtonTap(){
//        listener?.activeButtonDidTap()
//    }
//    
//    @objc
//    private func cancelButtonTap(){
//        listener?.cancelButtonDidTap()
//    }
//    

    
}
