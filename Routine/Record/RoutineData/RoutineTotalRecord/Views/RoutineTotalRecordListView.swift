//
//  RoutineTotalRecordListView.swift
//  Routine
//
//  Created by 한현규 on 11/6/23.
//

import UIKit




final class RoutineTotalRecordListView: UIView{
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setBoldFont(style: .footnote)
        label.textColor = .label
        return label
    }()
    
    
    private let doneLabel: UILabel = {
        let label = UILabel()
        label.setBoldFont(style: .headline)
        label.textColor = .label
        return label
    }()
    
    
    init(_ viewModel: RoutineTotalRecordListViewModel){
        super.init(frame: .zero)
        
        
        setView()
        bindView(viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    
    private func setView(){
        addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(doneLabel)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func bindView(_ viewModel: RoutineTotalRecordListViewModel){
        titleLabel.text = viewModel.title
        doneLabel.text = viewModel.done
    }
    
}
