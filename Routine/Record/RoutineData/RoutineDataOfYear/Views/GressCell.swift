//
//  GressCell.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import UIKit


final class GressCell: UICollectionViewCell{
    
    private var cellBackgroundColor = UIColor.systemGreen
    private let alphas = [ 0.1 , 0.3,  0.5 , 0.7, 0.9]
    
    private let gressView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .tertiaryLabel
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setView()
    }
    
    private func setView(){
        contentView.addSubview(gressView)
        
        gressView.roundCorners(1.0)
        
        
        NSLayoutConstraint.activate([
            gressView.topAnchor.constraint(equalTo: contentView.topAnchor),
            gressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        if Bool.random(){
            gressView.backgroundColor = cellBackgroundColor.withAlphaComponent(alphas.randomElement()!)
        }
    }
    
    func bindView(_ viewModel: GressCellViewModel){
        gressView.backgroundColor = viewModel.color
    }
    
}
