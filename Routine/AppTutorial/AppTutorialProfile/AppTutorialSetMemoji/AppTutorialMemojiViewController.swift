//
//  AppTutorialMemojiViewController.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import ModernRIBs
import UIKit
import Combine

protocol AppTutorialMemojiPresentableListener: AnyObject {
    func closeButtonDidTap()
    
    func didSetType(type: MemojiType)
    func didSetStyle(style: MemojiStyle)
                
    func segementControlValueChanged(index: Int)
    func memojiViewDidFocused()
}

final class AppTutorialMemojiViewController: UIViewController, AppTutorialMemojiPresentable, AppTutorialMemojiViewControllable {

    weak var listener: AppTutorialMemojiPresentableListener?
    
    private var cancellables: Set<AnyCancellable> = .init()
        
    private lazy var closeBarButtonItem: UIBarButtonItem = {
        let closebuttonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeBarButtonItemTap))
        return closebuttonItem
    }()
    
    private lazy var memojiView: MemojiView = {
        let memoji = MemojiView()
        memoji.translatesAutoresizingMaskIntoConstraints = false
        memoji.onChange = { [weak self] image, type in
            self?.listener?.didSetType(type: type)
        }
        memoji.onFocus = { [weak self] in
            self?.listener?.memojiViewDidFocused()
        }
        return memoji
    }()
  

    private lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Emoticon", "Style"])
        segmentControl.translatesAutoresizingMaskIntoConstraints  = false
        segmentControl.tintColor = .label
        
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.label,
            NSAttributedString.Key.font: UIFont.getFont(size: 16.0)
        ]
        
        segmentControl.setTitleTextAttributes( attributes, for: .normal )
        segmentControl.setTitleTextAttributes( attributes, for: .selected )
        segmentControl.addTarget(self, action: #selector(segmentControlValueChange(control:)), for: .valueChanged)
        return segmentControl
    }()
    

    private lazy var collectionView: MemojiStyleCollectionView = {
        let collectionView = MemojiStyleCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        collectionView.tapHandler = { [weak self] style in
            self?.listener?.didSetStyle(style: style)
        }
        return collectionView
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
        view.backgroundColor = .primaryColor
        
        navigationItem.rightBarButtonItem = closeBarButtonItem
        
        view.addSubview(memojiView)
        
        view.addSubview(segmentControl)
        view.addSubview(collectionView)
        
        
        
        let inset: CGFloat = 16.0
        
        let segmentBottomConstarint = segmentControl.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            memojiView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            memojiView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            memojiView.widthAnchor.constraint(equalToConstant: 120.0),
            memojiView.heightAnchor.constraint(equalToConstant: 120.0),
            memojiView.bottomAnchor.constraint(lessThanOrEqualTo: segmentControl.topAnchor, constant: -24.0),
                    
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            segmentBottomConstarint,
                        
            collectionView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 32.0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])                
        

        CombineKeyboard.shared.visibleHeight
            .sink { [weak self] keyboardVisibleHeight in
                guard let self = self else { return }
                
                if keyboardVisibleHeight <= 0{
                    return
                }
                
                let segmentConstraint = -(keyboardVisibleHeight + 16.0)
                
                if segmentBottomConstarint.constant != segmentConstraint{
                    segmentBottomConstarint.constant = -(keyboardVisibleHeight + 16.0)
                }
            }.store(in: &cancellables)

        memojiView.focus()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
 
    
    //MARK: Presentable
    
    func setType(type: MemojiType) {
        memojiView.setType(type)
        collectionView.setType(type)
    }

    func setStyle(style: MemojiStyle) {
        memojiView.setStyle(style)
    }
            

    func showMemojiLists() {
        memojiView.focus()
    }
    
    func hideMemojiLists() {
        view.endEditing(true)
    }
    
    func showStyleLists() {
        collectionView.isHidden = false
    }
    
    func hideStyleLists() {
        collectionView.isHidden = true
    }
    
    
    func setMemojiSegment() {
        segmentControl.selectedSegmentIndex = 0
    }
    
    func setStyleSegment() {
        segmentControl.selectedSegmentIndex = 1
    }
    

    @objc
    private func segmentControlValueChange(control: UISegmentedControl) {
        listener?.segementControlValueChanged(index: control.selectedSegmentIndex)
    }
    
    
    @objc
    private func closeBarButtonItemTap(){
        listener?.closeButtonDidTap()
    }
}
