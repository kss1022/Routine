//
//  ProfileEditMemojiViewController.swift
//  Routine
//
//  Created by 한현규 on 11/24/23.
//

import ModernRIBs
import UIKit

protocol ProfileEditMemojiPresentableListener: AnyObject {    

    func nameButtonDidTap()
    func descriptoinButtonDidTap()
    
    func didSetType(type: MemojiType)
    func didSetStyle(style: MemojiStyle)
    
    func segementControlValueChanged(index: Int)
    func memojiViewDidFocused()
}

final class ProfileEditMemojiViewController: UIViewController, ProfileEditMemojiPresentable, ProfileEditMemojiViewControllable {        

    weak var listener: ProfileEditMemojiPresentableListener?
    

    private var currentImage: UIImage?
        
    
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
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 8.0
        return stackView
    }()
    
    private lazy var nameButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .getBoldFont(size: 24.0)
        button.setTitleColor(.label, for: .normal)
        
//        button.setImage(UIImage(systemName: "square.and.pencil.circle"), for: .normal)
//        button.semanticContentAttribute = .forceRightToLeft
//        button.tintColor = .secondaryLabel
//        button.imageEdgeInsets.left = 16.0
        
        button.addTarget(self, action: #selector(nameButtonTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var descriptoinButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .getFont(size: 18.0)
        button.titleLabel?.numberOfLines = 2
        
        button.setTitleColor(.secondaryLabel, for: .normal)
        
//        button.setImage(UIImage(systemName: "square.and.pencil.circle"), for: .normal)
//        button.semanticContentAttribute = .forceRightToLeft
//        button.tintColor = .secondaryLabel
//        button.imageEdgeInsets.left = 16.0
        
        
        button.addTarget(self, action: #selector(descriptionButtonTap), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(
            items: [
                "emoticon".localized(tableName: "Profile"),
                "style".localized(tableName: "Profile")
            ]
        )
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
    
    private var collectionViewHeightConstraint: NSLayoutConstraint!
    
    private lazy var collectionView: MemojiStyleCollectionView = {
        
        let collectionView = MemojiStyleCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        collectionView.tapHandler = { [weak self] style in
            self?.listener?.didSetStyle(style: style)
        }
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 0.0)
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
        view.addSubview(memojiView)
        view.addSubview(labelStackView)
        view.addSubview(segmentControl)
        view.addSubview(collectionView)
        
        labelStackView.addArrangedSubview(nameButton)
        labelStackView.addArrangedSubview(descriptoinButton)
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            memojiView.topAnchor.constraint(equalTo: view.topAnchor, constant: 32.0),
            memojiView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            memojiView.widthAnchor.constraint(equalToConstant: 120.0),
            memojiView.heightAnchor.constraint(equalToConstant: 120.0),
            
            
            labelStackView.topAnchor.constraint(equalTo: memojiView.bottomAnchor, constant: 32.0),
            labelStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            labelStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            
            segmentControl.topAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: 32.0),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
                        
            collectionView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 32.0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.updateTransition()
        }, completion: nil)
    }
    
    private func updateTransition(){
        if UIDevice.current.orientation.isLandscape{
            let height = self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0))?.frame.height ?? 60.0
            collectionViewHeightConstraint.constant = height * 3
            collectionViewHeightConstraint.isActive = true
        }else{
            collectionViewHeightConstraint.isActive = false
        }
    }
    
    //MARK: Presentable
    
    func setName(name: String) {
        if name.isEmpty{
            nameButton.setTitle("add_your_name".localized(tableName: "Profile"), for: .normal)
            return
        }
        
        nameButton.setTitle(name, for: .normal)
    }
    
    func setDescription(description: String) {
        if description.isEmpty{
            descriptoinButton.setTitle("introduce_yourself".localized(tableName: "Profile"), for: .normal)
            return
        }
        
        descriptoinButton.setTitle(description, for: .normal)
    }
    
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
    private func nameButtonTap(){
        listener?.nameButtonDidTap()
    }
    
    @objc
    private func descriptionButtonTap(){
        listener?.descriptoinButtonDidTap()
    }
    
    @objc
    private func segmentControlValueChange(control: UISegmentedControl) {
        listener?.segementControlValueChanged(index: control.selectedSegmentIndex)
    }
    
    
}
