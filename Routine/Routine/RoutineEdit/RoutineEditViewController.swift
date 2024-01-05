//
//  RoutineEditViewController.swift
//  Routine
//
//  Created by 한현규 on 10/1/23.
//

import ModernRIBs
import UIKit
import Combine

protocol RoutineEditPresentableListener: AnyObject {
    func closeButtonDidTap()
    func doneButtonDidTap()
    func deleteBarButtonDidTap()
}

final class RoutineEditViewController: UIViewController, RoutineEditPresentable, RoutineEditViewControllable {

    weak var listener: RoutineEditPresentableListener?
    
    private var cancelables :  Set<AnyCancellable>
    
    private lazy var closeBarButtonItem: UIBarButtonItem = {
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeBarButtonTap))
        return closeButton
    }()
    
    private lazy var doneBarButtonItem : UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBarButtonTap))
        return barButtonItem
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = TouchesButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.titleLabel?.font = .getBoldFont(size: 14.0)
        button.setTitle("delete".localized(tableName: "Routine"), for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .label
                                
        button.contentEdgeInsets.top = 16.0
        button.contentEdgeInsets.bottom = 16.0
        button.contentEdgeInsets.left = 32.0
        button.contentEdgeInsets.right = 32.0
        
        button.roundCorners(24.0)
        button.addTarget(self, action: #selector(deleteButtonTap), for: .touchUpInside)
        
        return button
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
        
        navigationItem.leftBarButtonItem = closeBarButtonItem
        navigationItem.rightBarButtonItem = doneBarButtonItem
        scrollView.addSubview(stackView)
        scrollView.addSubview(deleteButton)
        
        
        
        let inset : CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            //stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            
            deleteButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16.0),
            deleteButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16.0),
            deleteButton.heightAnchor.constraint(equalToConstant: 48.0)
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
    
    func addRepeat(_ view: ModernRIBs.ViewControllable) {
        let vc = view.uiviewController
        addChild(vc)
        
        let view = vc.view!
        view.roundCorners()
        
        stackView.addArrangedSubview(view)
        vc.didMove(toParent: self)
    }
    
    func addReminder(_ view: ViewControllable) {
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
    private func closeBarButtonTap(){
        listener?.closeButtonDidTap()
    }
    
    
    @objc
    private func doneBarButtonTap(){
        view.endEditing(true)
        self.listener?.doneButtonDidTap()
    }
    
    @objc
    private func deleteButtonTap(){
        view.endEditing(true)
        self.listener?.deleteBarButtonDidTap()
    }

}
