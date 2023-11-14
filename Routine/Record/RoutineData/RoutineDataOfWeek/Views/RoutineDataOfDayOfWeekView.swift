//
//  RoutineDataOfDayOfWeekView.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import UIKit


final class RoutineDataOfDayOfWeekView: UIView{
    
    private var doneColor: UIColor = .primaryColor
    private var baseColor: UIColor = .secondaryLabel
    private var done: Bool = false
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 4.0
        return stackView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    private let weekLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 8.0, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.circle.fill")
        imageView.tintColor = self.baseColor
        return imageView
    }()
    
    
    init(){
        super.init(frame: .zero)
                        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    
    
    private func setView(){
        addSubview(stackView)
        
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(weekLabel)
        stackView.addArrangedSubview(checkImageView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func bindView(_ viewModel: RoutineDataOfWeekViewModel){
        self.done = viewModel.done
        
        dateLabel.text = viewModel.date
        weekLabel.text = viewModel.week
        checkImageView.tintColor = self.done ? self.doneColor : self.baseColor
    }
    
    func setImage(image: UIImage?, tintColor: UIColor){        
        self.doneColor = tintColor
        checkImageView.image = image
        checkImageView.tintColor = self.done ? self.doneColor : self.baseColor
    }
    
}
