//
//  RoutineImojiIconViewController.swift
//  Routine
//
//  Created by 한현규 on 2023/09/26.
//

import ModernRIBs
import UIKit

protocol RoutineImojiIconPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RoutineImojiIconViewController: UIViewController, RoutineImojiIconPresentable, RoutineImojiIconViewControllable {

    weak var listener: RoutineImojiIconPresentableListener?
    
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 8.0
        return stackView
    }()
    
    init(){
        super.init(nibName: nil, bundle: nil)
        
        setLayout()
        setImoji()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setLayout()
        setImoji()
    }
    
    
    
    private func setLayout(){
        view.backgroundColor = .secondarySystemBackground
        
        view.addSubview(verticalStackView)
        
        let inset : CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: inset),
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            verticalStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset)
        ])
    }
    
    private func horizontalStaciView() -> UIStackView{
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8.0
        return stackView
    }
    
    private func setImoji(){
        let imojis : [String] = [
            "🌟" ,"🍎" ,"🚀" ,"🐱" ,"🌸" ,"🎉", "📷" ,"💡" ,"🎈" ,"🌞" ,"🍕" ,"🚲" ,"🌈" , "🎵", "🏆", "🍔","⌚️","🌍","📚", "🤖"
        ]
        
        let n = 5
        
        for startIndex in stride(from: 0, to: imojis.count, by: n) {
            let endIndex = min(startIndex + n, imojis.count)
            let sublist = Array(imojis[startIndex..<endIndex])
            
            let horizointalStackView = horizontalStaciView()
            verticalStackView.addArrangedSubview(horizointalStackView)
            
            sublist.map { imoji in
                let button = TouchesButton()
                button.backgroundColor = .lightGray
                button.setTitle(imoji, for: .normal)
                
                button.setFont(style: .largeTitle)
                button.titleLabel?.adjustsFontSizeToFitWidth = true
                
                button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
                button.contentEdgeInsets.top = 8.0
                button.contentEdgeInsets.left = 8.0
                button.contentEdgeInsets.right = 8.0
                button.contentEdgeInsets.bottom = 8.0
                button.roundCorners()
                
                return button
            }.forEach { view in
                horizointalStackView.addArrangedSubview(view)
            }
        }
    }

}
