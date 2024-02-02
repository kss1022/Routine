//
//  FocusResultViewController.swift
//  Routine
//
//  Created by 한현규 on 10/31/23.
//

import ModernRIBs
import UIKit

protocol FocusResultPresentableListener: AnyObject {
}

final class FocusResultViewController: UIViewController, FocusResultPresentable, FocusResultViewControllable {

    weak var listener: FocusResultPresentableListener?
    
    
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
        stackView.spacing = 16.0
        return stackView
    }()
    
    
    private let focusResultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        let text = "All of this just to underline some text? Cool."
        
        let range = NSRange(location: 20, length: 9)

        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single,
            range: range
        )
        attributedText.addAttribute(
            .underlineColor,
            value: UIColor.white,
            range: range
        )
        label.attributedText = attributedText
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
        view.backgroundColor = .orange
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        stackView.addArrangedSubview(focusResultLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

}
