//
//  RoutineEmojiIconViewController.swift
//  Routine
//
//  Created by 한현규 on 9/30/23.
//

import ModernRIBs
import UIKit

protocol RoutineEmojiIconPresentableListener: AnyObject {
    func emojiButtonDidTap(emoji: String)
}

final class RoutineEmojiIconViewController: UIViewController, RoutineEmojiIconPresentable, RoutineEmojiIconViewControllable {

    weak var listener: RoutineEmojiIconPresentableListener?
    
    private let n : Int = 5
    private var selectedButton: UIButton?
    
    
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
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setLayout()
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
    
    
    func setEmojis(_ emojis: [String]) {
        for startIndex in stride(from: 0, to: emojis.count, by: n) {
            let endIndex = min(startIndex + n, emojis.count)
            let sublist = Array(emojis[startIndex..<endIndex])
            
            let horizointalStackView = horizontalStaciView()
            verticalStackView.addArrangedSubview(horizointalStackView)
            
            sublist.map { emoji in
              emojiButton(emoji)
            }.forEach { view in
                horizointalStackView.addArrangedSubview(view)
            }
        }
        
    }
    
    func setEmoji(pos: Int) {
        if let verticalView = self.verticalStackView.arrangedSubviews[safe: pos / n] as? UIStackView,
            let button = verticalView.arrangedSubviews[safe: pos % n] as? UIButton{
             setSelectedBorder(button)
         }
    }
            
    
    private func horizontalStaciView() -> UIStackView{
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8.0
        return stackView
    }
    
    
    private func emojiButton(_ emoji: String ) -> UIButton{
        let button = TouchesButton()
        button.backgroundColor = .lightGray
        button.setTitle(emoji, for: .normal)
        
        button.titleLabel?.font = .systemFont(ofSize: 34.0)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        
        
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.contentEdgeInsets.top = 8.0
        button.contentEdgeInsets.left = 8.0
        button.contentEdgeInsets.right = 8.0
        button.contentEdgeInsets.bottom = 8.0
        button.roundCorners()
        
        button.addTarget(self, action: #selector(emojiButtonTap), for: .touchUpInside)
        
        return button
    }
    
    
    private func setSelectedBorder(_ button: UIButton){
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 1.0
        selectedButton = button
    }
    
    private func setUnSelectedBorder(_ button: UIButton){
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = 0.0
    }
    
    @objc
    private func emojiButtonTap(button: UIButton){
        if let emoji = button.titleLabel?.text{
            listener?.emojiButtonDidTap(emoji: emoji)
            
            if let selectedButton = selectedButton{
                setUnSelectedBorder(selectedButton)
            }
            
            setSelectedBorder(button)
        }
    }
    

}
