//
//  RecordTimerListHeaderView.swift
//  Routine
//
//  Created by 한현규 on 11/9/23.
//

import UIKit



final class RecordTimerListHeaderView : UICollectionReusableView{
    
    static let identifier = "RecordTimerListHeaderView"
    
    let titleButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setImage(UIImage(systemName: "chevron.right")?.setSize(pointSize: 14.0, weight: .bold), for: .normal)        
        button.setBoldFont(style: .title3)
        button.setTitleColor(.label, for: .normal)
        
        button.tintColor = .secondaryLabel
        
        let direction: UISemanticContentAttribute
        UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? (direction = .forceLeftToRight) : (direction = .forceRightToLeft)
        button.semanticContentAttribute = direction
                            
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView(){
        addSubview(titleButton)
        
        let inset : CGFloat = 8.0
        
        NSLayoutConstraint.activate([
            titleButton.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            titleButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleButton.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            titleButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset),
        ])
    }
    
    func setTitle(title: String){
        self.titleButton.setTitle(title, for: .normal)
    }
}


