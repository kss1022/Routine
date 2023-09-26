//
//  RoutineTintViewController.swift
//  Routine
//
//  Created by 한현규 on 2023/09/26.
//

import ModernRIBs
import UIKit

protocol RoutineTintPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RoutineTintViewController: UIViewController, RoutineTintPresentable, RoutineTintViewControllable {

    weak var listener: RoutineTintPresentableListener?
    
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
        setTint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setLayout()
        setTint()
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
        
    private func horizontalStaciView() -> UIStackView{
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8.0
        
        return stackView
    }
    
    private func setTint(){
        let pastelColors: [UIColor] = [
            UIColor(red: 255/255, green: 204/255, blue: 204/255, alpha: 1.0), // 연한 분홍
            UIColor(red: 255/255, green: 229/255, blue: 204/255, alpha: 1.0), // 연한 주황
            UIColor(red: 255/255, green: 255/255, blue: 204/255, alpha: 1.0), // 연한 노랑
            UIColor(red: 204/255, green: 255/255, blue: 204/255, alpha: 1.0), // 연한 민트 그린
            UIColor(red: 204/255, green: 255/255, blue: 255/255, alpha: 1.0), // 연한 파랑
            UIColor(red: 204/255, green: 204/255, blue: 255/255, alpha: 1.0), // 연한 보라
            UIColor(red: 229/255, green: 204/255, blue: 255/255, alpha: 1.0), // 연한 핑크 보라
            UIColor(red: 255/255, green: 204/255, blue: 255/255, alpha: 1.0), // 연한 분홍 보라
            UIColor(red: 255/255, green: 204/255, blue: 229/255, alpha: 1.0), // 연한 코랄
            UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1.0) // 연한 회색
        ]
        
        let n = 5
        
        for startIndex in stride(from: 0, to: pastelColors.count, by: n) {
            let endIndex = min(startIndex + n, pastelColors.count)
            let sublist = Array(pastelColors[startIndex..<endIndex])
            
            let horizointalStackView = horizontalStaciView()
            verticalStackView.addArrangedSubview(horizointalStackView)
            sublist.map { color in
                let button = TouchesButton()
                button.backgroundColor = color
                button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
                button.roundCorners()                
                return button
            }.forEach { view in
                horizointalStackView.addArrangedSubview(view)
            }
                    
        }
    }

}
