//
//  AddYourRoutineViewController.swift
//  Routine
//
//  Created by 한현규 on 2023/09/26.
//

import ModernRIBs
import UIKit
import Combine

protocol AddYourRoutinePresentableListener: AnyObject {
    func doneBarButtonDidTap()
}

final class AddYourRoutineViewController: UIViewController, AddYourRoutinePresentable, AddYourRoutineViewControllable {
    
    
    
    weak var listener: AddYourRoutinePresentableListener?
    
    private var cancelables :  Set<AnyCancellable>
    
    private lazy var doneBarButtonItem : UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBarButtonTap))
        return barButtonItem
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .onDrag
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 16.0
        return stackView
    }()
    
    
    init(){
        cancelables = .init()
        super.init(nibName: nil, bundle: nil)
        
        setLayout()        
    }
    
    
    required init?(coder: NSCoder) {
        cancelables = .init()
        super.init(coder: coder)
        
        setLayout()
    }
    
    private func setLayout(){
        title = "Add Your Routine"
        
        view.addSubview(scrollView)
        
        navigationItem.rightBarButtonItem = doneBarButtonItem
        scrollView.addSubview(stackView)
        
        
        
        
        let inset : CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        CombineKeyboard.shared.visibleHeight
            .sink { [weak self] keyboardVisibleHeight in
                guard let self = self else { return }
                UIView.animate(withDuration: 0) {
                    self.scrollView.contentInset.bottom = keyboardVisibleHeight
                    self.scrollView.verticalScrollIndicatorInsets.bottom = self.scrollView.contentInset.bottom
                    self.view.layoutIfNeeded()
                }
            }.store(in: &cancelables)
    }
    
    
    func addTitle(_ view: ViewControllable) {
        let vc = view.uiviewController
        addChild(vc)
        
        let view = vc.view!
        view.roundCorners()
        
        stackView.addArrangedSubview(view)
        vc.didMove(toParent: self)
    }
    
    func addTint(_ view: ViewControllable) {
        let vc = view.uiviewController
        addChild(vc)
        
        let view = vc.view!
        view.roundCorners()
        
        stackView.addArrangedSubview(view)
        vc.didMove(toParent: self)
    }
    
    func addEmojiIcon(_ view: ViewControllable) {
        let vc = view.uiviewController
        addChild(vc)
        
        let view = vc.view!
        view.roundCorners()
        
        stackView.addArrangedSubview(view)
        vc.didMove(toParent: self)
    }

    func addRepeat(_ view: ViewControllable) {
        let vc = view.uiviewController
        addChild(vc)
        
        let view = vc.view!
        view.roundCorners()
        
        stackView.addArrangedSubview(view)
        vc.didMove(toParent: self)
    }
    
    func addReminder(_ view: ModernRIBs.ViewControllable) {
        let vc = view.uiviewController
        addChild(vc)
        
        let view = vc.view!
        view.roundCorners()
        
        stackView.addArrangedSubview(view)
        vc.didMove(toParent: self)
    }
    
    func setTint(_ color: String) {
        view.backgroundColor = UIColor(hex: color)
    }
    

    
    @objc
    private func doneBarButtonTap(){
        view.endEditing(true)
        listener?.doneBarButtonDidTap()
    }
    
}
