//
//  FocusRoundTimerView.swift
//  Routine
//
//  Created by 한현규 on 10/31/23.
//

import UIKit


class FocusRoundTimerView: RoundTimerView {
    

    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .getBoldFont(size: 44.0)
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
        self.barLayerStrokeColor = UIColor.white.cgColor
        
        addSubview(emojiLabel)
    
                        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    
      
      func bindView(_ viewModel: FocusRoundTimerViewModel){
          emojiLabel.text = viewModel.emoji
      }

}
