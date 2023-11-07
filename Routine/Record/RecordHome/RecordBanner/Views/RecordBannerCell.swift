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
    
//    private let barChartView: RecordBarChartView = {
//        let barCharView = RecordBarChartView()
//        barCharView.translatesAutoresizingMaskIntoConstraints = false
//        barCharView.bindView(BarChartViewModel())
//        return barCharView
//    }()
//    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setView()
    }
    
    
    private func setView(){
        contentView.roundCorners()
        
//        contentView.addSubview(barChartView)
//        NSLayoutConstraint.activate([
//            barChartView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24.0),
//            barChartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24.0),
//            barChartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24.0),
//            barChartView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24.0),
//        ])
        
//        contentView.addSubview(cardView)
//        NSLayoutConstraint.activate([
//            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//        ])
    }
}
