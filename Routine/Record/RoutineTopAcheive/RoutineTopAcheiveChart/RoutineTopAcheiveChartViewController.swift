//
//  RoutineTopAcheiveChartViewController.swift
//  Routine
//
//  Created by 한현규 on 11/13/23.
//

import ModernRIBs
import UIKit

protocol RoutineTopAcheiveChartPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RoutineTopAcheiveChartViewController: UIViewController, RoutineTopAcheiveChartPresentable, RoutineTopAcheiveChartViewControllable {

    weak var listener: RoutineTopAcheiveChartPresentableListener?
    
    private let periodLabel: UILabel = {
        let label = UILabel()
        label.setBoldFont(style: .subheadline)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        return label
    }()
    
    
    private let cardView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .label
        view.addShadowWithRoundedCorners(shadowColor: UIColor.systemBackground.cgColor)
        return view
    }()
    
    private let topAcheiveChart: TopAcheiveChartView = {
        let chart = TopAcheiveChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
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
        
        view.addSubview(periodLabel)
        
        view.addSubview(cardView)
        cardView.addSubview(topAcheiveChart)
        

        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            periodLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: inset),
            periodLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            
                        
            cardView.topAnchor.constraint(equalTo: periodLabel.bottomAnchor, constant: 32.0),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset),
            
            
            topAcheiveChart.topAnchor.constraint(equalTo: cardView.topAnchor, constant: inset),
            topAcheiveChart.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: inset),
            topAcheiveChart.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -inset),
            topAcheiveChart.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -inset),
            topAcheiveChart.heightAnchor.constraint(equalToConstant: 300.0)
        ])
    }
    
    func setChart(_ viewModels: [TopAcheiveChartViewModel]){
        periodLabel.text = "2023.10.13 ~ 2023.11.13"
        topAcheiveChart.bindView(viewModels)
    }
}
