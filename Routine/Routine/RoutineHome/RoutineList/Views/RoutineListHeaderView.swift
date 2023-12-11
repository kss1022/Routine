//
//  RoutineListHeaderView.swift
//  Routine
//
//  Created by 한현규 on 12/7/23.
//

import UIKit


final class  RoutineListHeaderView : UICollectionReusableView{
    
    static let identifier = "RoutineListHeaderView"
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setBoldFont(style: .title3)
        label.textColor = .label
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView(){
        addSubview(label)                
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func setTitle(title: String){
        label.text = title
    }
}


