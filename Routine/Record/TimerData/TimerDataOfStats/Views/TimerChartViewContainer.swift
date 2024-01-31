//
//  TimerChartViewContainer.swift
//  Routine
//
//  Created by 한현규 on 1/31/24.
//

import UIKit



final class TimerChartViewContainer: UIView{
    
    init(){
        super.init(frame: .zero)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setView()
    }
    
    private func setView(){
        backgroundColor = .systemBackground
        addShadowWithRoundedCorners()
    }
    
    func setCharView(_ view: UIView){
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset),
        ])
    }
}
