//
//  RoutineTitleViewController.swift
//  Routine
//
//  Created by 한현규 on 9/30/23.
//

import ModernRIBs
import UIKit

protocol RoutineTitlePresentableListener: AnyObject {
    func completeButtonDidTap()
}

final class RoutineTitleViewController: UIViewController, RoutineTitlePresentable, RoutineTitleViewControllable {

    weak var listener: RoutineTitlePresentableListener?
    
    
    private var emojiLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setFont(style: .largeTitle)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    private let stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 8.0
        return stackView
    }()
    
    private let routineNameLabel: UILabel = {
        let label = UILabel()
        label.setBoldFont(style: .title1)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.tag = 1
        return label
    }()
    
    private let routineDescriptionLabel: UILabel = {
        let label = UILabel()
        label.setFont(style: .headline)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var completeButton: UIButton = {
        let button = TouchesRoundButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.titleLabel?.font = .getBoldFont(size: 14.0)
        //button.setTitle("Complete", for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .label
        
        let buttonInset: CGFloat = 16.0
        
        button.contentEdgeInsets.top = buttonInset
        button.contentEdgeInsets.bottom = buttonInset
        button.contentEdgeInsets.left = buttonInset
        button.contentEdgeInsets.right = buttonInset
        
        button.roundCorners(24.0)
        
        button.addTarget(self, action: #selector(completeButtonTap), for: .touchUpInside)
        return button
    }()

    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setLayout()        
    }
    
    private func setLayout(){
     
        view.addSubview(emojiLabel)
        view.addSubview(stackView)
        view.addSubview(completeButton)
        
        stackView.addArrangedSubview(routineNameLabel)
        stackView.addArrangedSubview(routineDescriptionLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: view.topAnchor),
            emojiLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: 80.0),
            emojiLabel.heightAnchor.constraint(equalToConstant: 80.0),
            
            stackView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 8.0),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            completeButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 32.0),
            completeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            completeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16.0)
        ])
        
        
    }
    
    func setRoutineTitle(_ viewModel: RoutineTitleViewModel) {
        emojiLabel.text = viewModel.emojiIcon
        routineNameLabel.text = viewModel.routineName
        routineDescriptionLabel.text = viewModel.routineDescription
    }
    
    func setIsComplete(_ isComplete: Bool) {
        if isComplete{
            self.completeButton.setAttributedTitle("Completed".getAttributeStrkeString(), for: .normal)
        }else{
            self.completeButton.setAttributedTitle("Complete".getAttributeSting(), for: .normal)
        }
    }
    
    @objc
    private func completeButtonTap(){
        listener?.completeButtonDidTap()
    }

}
