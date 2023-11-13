//
//  RecordStreakBannerCell.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import UIKit



final class RecordTopAcheiveBannerCell: UICollectionViewCell{
    
    
    
    private let topAcheiveChartView: TopAcheiveChartView = {
        let view = TopAcheiveChartView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Check Your Top Acheive🔥"
        label.font = .systemFont(ofSize: 18.0, weight: .bold)
        label.textColor = .systemBackground
        label.numberOfLines = 2
        return label
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
        contentView.roundCorners()
        
        
        contentView.addSubview(topAcheiveChartView)
        contentView.addSubview(titleLabel)
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            topAcheiveChartView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            topAcheiveChartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.0),
            topAcheiveChartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32.0),
            topAcheiveChartView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -inset),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
        ])
        
        titleLabel.setContentHuggingPriority(.init(249.0), for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.init(751.0), for: .vertical)
        
        
        setTopAcheive()
    }
    
    private func setTopAcheive(){
        let models = [
            TopAcheiveChartModel(
                title: "💊",
                count: Int.random(in: 20...80),
                tint: "#FFCCCCFF"
            ),
            TopAcheiveChartModel(
                title: "🏃",
                count: Int.random(in: 20...80),
                tint: "#FFFFCCFF"
            ),
            TopAcheiveChartModel(
                title: "💪",
                count: Int.random(in: 20...80),
                tint: "#E5CCFFFF"
            ),
            TopAcheiveChartModel(
                title: "✍️",
                count: Int.random(in: 20...80),
                tint: "#FFCCE5FF"
            ),
            TopAcheiveChartModel(
                title: "🚗",
                count: Int.random(in: 20...80),
                tint: "#CCFFFFFF"
            ),
            TopAcheiveChartModel(
                title: "💧",
                count: Int.random(in: 20...80),
                tint: "#FFCCCCFF"
            ),
            TopAcheiveChartModel(
                title: "📖",
                count: Int.random(in: 20...80),
                tint: "#C0C0C0FF"
            ),
            TopAcheiveChartModel(
                title: "🏀",
                count: Int.random(in: 20...80),
                tint: "#FFE5CCFF"
            ),
            TopAcheiveChartModel(
                title: "🍻",
                count: Int.random(in: 20...80),
                tint: "#CCFFCCFF"
            ),
        ]

        let viewModels = models.enumerated().map { index, model in
            TopAcheiveChartViewModel(index: index, model)
        }
        
        topAcheiveChartView.bindView(viewModels)
    }
}
