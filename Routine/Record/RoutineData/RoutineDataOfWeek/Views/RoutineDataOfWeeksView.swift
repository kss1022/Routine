//
//  RoutineDataOfWeeksView.swift
//  Routine
//
//  Created by 한현규 on 11/13/23.
//

import Foundation
import UIKit



final class RoutineDataOfWeeksView: UIView{
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 16.0
        return stackView
    }()
    
    private let sundayView: RoutineDataOfDayOfWeekView = {
        let view = RoutineDataOfDayOfWeekView()
        return view
    }()
    
    private let mondayView: RoutineDataOfDayOfWeekView = {
        let view = RoutineDataOfDayOfWeekView()
        return view
    }()
    
    private let tuesdayView: RoutineDataOfDayOfWeekView = {
        let view = RoutineDataOfDayOfWeekView()
        return view
    }()
    
    private let wednesdayView: RoutineDataOfDayOfWeekView = {
        let view = RoutineDataOfDayOfWeekView()
        return view
    }()
    
    
    private let thursdayView: RoutineDataOfDayOfWeekView = {
        let view = RoutineDataOfDayOfWeekView()
        return view
    }()
    
    private let fridayView: RoutineDataOfDayOfWeekView = {
        let view = RoutineDataOfDayOfWeekView()
        return view
    }()
    
    private let saturdaysView: RoutineDataOfDayOfWeekView = {
        let view = RoutineDataOfDayOfWeekView()
        return view
    }()
    
    
    init(){
        super.init(frame: .zero)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setView()
    }
    
    private func setView(){
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        
        stackView.addArrangedSubview(sundayView)
        stackView.addArrangedSubview(mondayView)
        stackView.addArrangedSubview(tuesdayView)
        stackView.addArrangedSubview(wednesdayView)
        stackView.addArrangedSubview(thursdayView)
        stackView.addArrangedSubview(fridayView)
        stackView.addArrangedSubview(saturdaysView)
    }
    
    
    func bindView(_ viewModel: RoutineDataOfWeekListViewModel){
        [sundayView , mondayView ,tuesdayView ,wednesdayView, thursdayView, fridayView, saturdaysView].forEach { $0.setImage(image: viewModel.image, tintColor: viewModel.imageTintColor) }
        
        sundayView.bindView(viewModel.sun)
        mondayView.bindView(viewModel.mon)
        tuesdayView.bindView(viewModel.tue)
        wednesdayView.bindView(viewModel.wed)
        thursdayView.bindView(viewModel.thu)
        fridayView.bindView(viewModel.fri)
        saturdaysView.bindView(viewModel.sat)
    }
    
}
