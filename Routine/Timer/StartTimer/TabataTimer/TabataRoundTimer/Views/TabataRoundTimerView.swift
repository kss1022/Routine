//
//  TabataRoundTimerView.swift
//  Routine
//
//  Created by 한현규 on 1/18/24.
//

import UIKit



class TabataRoundTimerView: RoundTimerView {
    
   
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 8.0
        return stackView
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 44.0, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .getFont(size: 36.0)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        return label
    }()
    
    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 4.0
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .getFont(size: 18.0)
        label.textAlignment = .center
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let descriptoinLabel: UILabel = {
        let label = UILabel()
        label.font = .getFont(size: 16.0)
        label.textAlignment = .center
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(){
        super.init()
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setView()
    }
    

    private func setView() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(emojiLabel)
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(bottomStackView)
    
        
        bottomStackView.addArrangedSubview(nameLabel)
        bottomStackView.addArrangedSubview(descriptoinLabel)
        
                        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0 / sqrt(2), constant: -(lineWidth * 2)),
            stackView.heightAnchor.constraint(equalTo: stackView.widthAnchor),
        ])
        
        nameLabel.setContentHuggingPriority(.init(248.0), for: .vertical)
        nameLabel.setContentCompressionResistancePriority(.init(751.0), for: .vertical)
    }
    

    
    func bindView(_ viewModel: TabataRoundTimerViewModel){
        emojiLabel.text = viewModel.emoji
        nameLabel.text = viewModel.name
        timeLabel.text = viewModel.time
        descriptoinLabel.text = viewModel.description
    }
    
    
    func setTimeLabel(time: String){
        timeLabel.text = time
    }

}
