//
//  RoutineDetailViewController.swift
//  Routine
//
//  Created by 한현규 on 9/30/23.
//

import ModernRIBs
import UIKit

protocol RoutineDetailPresentableListener: AnyObject {
    func closeButtonDidTap()
    func editButtonDidTap()
}

final class RoutineDetailViewController: UIViewController, RoutineDetailPresentable, RoutineDetailViewControllable {

    weak var listener: RoutineDetailPresentableListener?
    
    var panGestureRecognizer: UIPanGestureRecognizer!

    //Title Gesture
    private var routineNameLabel : UIView?
    private var routineName: String?

    private lazy var closeBarButtonItem: UIBarButtonItem = {
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeBarButtonTap))
        return closeButton
    }()
    
    private lazy var editBarButtonItem: UIBarButtonItem = {
        let editButton = RoutineEditButton()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(editBarButtonTap))
        editButton.addGestureRecognizer(tap)
        
        let barButtonItem = UIBarButtonItem(customView: editButton)
        return barButtonItem
    }()
            
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 24.0
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
        view.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = closeBarButtonItem
        navigationItem.rightBarButtonItem = editBarButtonItem
        
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.addSubview(stackView)
                
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }

    
//    override func didMove(toParent parent: UIViewController?) {
//        super.didMove(toParent: parent)
//        if parent == nil{
//            listener?.didMoved()
//        }
//    }
    
    //MARK: ViewControllable
    func addTitle(_ view: ViewControllable) {
        let vc = view.uiviewController
        
        addChild(vc)
        stackView.addArrangedSubview(vc.view)
        self.routineNameLabel = findSubviewInView(view: vc.view, withTag: 1)    //RoutineTitleViewController routineNameLabel's Tag
        vc.didMove(toParent: self)
    }
    
    func addRecordCalendar(_ view: ViewControllable) {
        let vc = view.uiviewController
        
        addChild(vc)
        vc.view.roundCorners()
        stackView.addArrangedSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    func addBasicInfo(_ view: ViewControllable) {
        let vc = view.uiviewController
        
        addChild(vc)
        stackView.addArrangedSubview(vc.view)
        vc.didMove(toParent: self)
    }

    // MARK: Presentable
    func setTitle(_ title: String) {
        self.routineName = title
    }
    
    func setBackgroundColor(_ tint: String) {
        view.backgroundColor = UIColor(hex: tint)
    }
    
    func showRecordRoutineFailed() {
        let alert = UIAlertController(
            title: nil,
            message: "record_routine_failed".localized(tableName: "Routine"),
            preferredStyle: .alert
        )
        let confirm = UIAlertAction(title: "confirm".localized(tableName: "Routine"), style: .default)
        alert.addAction(confirm)
    }
    
    @objc
    private func closeBarButtonTap(){
        self.listener?.closeButtonDidTap()
    }
    
    @objc
    private func editBarButtonTap(){
        self.listener?.editButtonDidTap()
    }
}



extension RoutineDetailViewController : UIScrollViewDelegate{
        
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        guard let targetView = routineNameLabel else { return }
        guard let navigationBar =  navigationController?.navigationBar else { return }
        let targetViewFrame = targetView.convert(targetView.bounds, to: navigationBar)
        if (targetViewFrame.midY > navigationBar.frame.height / 2){
            self.title = nil
        }else{
            self.title = routineName
        }
    }
    
    private func findSubviewInView(view: UIView, withTag tag: Int) -> UIView? {
        if view.tag == tag {
            return view
        }
        
        for subview in view.subviews {
            if let foundView = findSubviewInView(view: subview, withTag: tag) {
                return foundView
            }
        }
        return nil
    }

  
}
