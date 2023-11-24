//
//  ProfileStatSegmentButton  tn.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import UIKit


final class ProfileStatSegmentButton : UIButton{
    
    private let borderView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override var isSelected: Bool {
        didSet {
            borderView.backgroundColor = isSelected ? .label : .clear
        }
    }
    
    init(title : String){
        super.init(frame: .zero)
        
        setView()
        setTitle(title, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        
        setView()
    }
    
    
    private func setView(){
        addSubview(borderView)
        
        
        NSLayoutConstraint.activate([
            borderView.heightAnchor.constraint(equalToConstant: 3.0),
            borderView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            borderView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        let contentInset : CGFloat = 16.0
        self.contentEdgeInsets = .init(top: contentInset, left: 0.0, bottom: contentInset, right: 0.0)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    
}
