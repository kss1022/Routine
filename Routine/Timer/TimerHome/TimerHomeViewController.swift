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
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
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
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    
    
    //MARK: ViewControllerable
    func setTimerList(_ view: ViewControllable) {
        let vc = view.uiviewController
        addChild(vc)        
        stackView.addArrangedSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    // MARK: Presentable
    func showError(title: String, message: String) {
        showAlert(title: title, message: message)
    }
    
    
    @objc
    private func createTimerBarButtonTap(){
        listener?.creatTimerButtonDidTap()
    }
    
    
    
}
