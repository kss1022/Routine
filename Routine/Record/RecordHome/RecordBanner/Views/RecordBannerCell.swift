//
//  RecordBannerCell.swift
//  Routine
//
//  Created by 한현규 on 11/2/23.
//

import UIKit



final class RecordBannerCell: UICollectionViewCell{
    
    
    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.roundCorners()
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
        contentView.backgroundColor = .gray
        contentView.roundCorners()
//        contentView.addSubview(cardView)
//        NSLayoutConstraint.activate([
//            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//        ])
    }
}
