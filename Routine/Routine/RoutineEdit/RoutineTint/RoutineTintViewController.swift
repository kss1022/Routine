//
//  RoutineTintViewController.swift
//  Routine
//
//  Created by 한현규 on 2023/09/26.
//

import ModernRIBs
import UIKit

protocol RoutineTintPresentableListener: AnyObject {
    func tintButtonDidTap(color: String)
}

final class RoutineTintViewController: UIViewController, RoutineTintPresentable, RoutineTintViewControllable {
    
    
    weak var listener: RoutineTintPresentableListener?
    
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
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: inset),
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            verticalStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset)
        ])
        
    }
    
    func setTints(tints: [String]) {
        let tints = tints.compactMap { UIColor(hex: $0) }
        
        for startIndex in stride(from: 0, to: tints.count, by: n) {
            let endIndex = min(startIndex + n, tints.count)
            let sublist = Array(tints[startIndex..<endIndex])
            
            let horizointalStackView = horizontalStaciView()
            verticalStackView.addArrangedSubview(horizointalStackView)
            sublist.map { color in
                tintButton(color)
            }.forEach { view in
                horizointalStackView.addArrangedSubview(view)
            }
        }
    }
    
    
    func setTint(pos: Int) {
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
    
    private func tintButton(_ color: UIColor) -> UIButton{
        let button = TouchesButton()
        button.backgroundColor = color
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.roundCorners()
        button.addTarget(self, action: #selector(tintButtonTap), for: .touchUpInside)
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
    private func tintButtonTap(button: UIButton){
        if let color = button.backgroundColor?.toHex(){
            listener?.tintButtonDidTap(color: color)
            
            if let selectedButton = selectedButton{
                setUnSelectedBorder(selectedButton)
            }
            
            setSelectedBorder(button)
        }
    }


}
