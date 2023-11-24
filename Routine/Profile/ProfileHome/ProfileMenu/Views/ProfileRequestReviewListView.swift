//
//  ProfileRequestReviewListView.swift
//  Routine
//
//  Created by 한현규 on 11/22/23.
//

import UIKit




final class ProfileRequestReviewListView: UIControl{
    
    private var tapHandler: (() -> Void)?
    
    private var emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "🙏"
        label.font = .systemFont(ofSize: 48.0)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let requestLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .getBoldFont(size: 16.0)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "Enjoing Routine?\n5 stars please"
        return label
    }()
    
    private let starLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "⭐️ ⭐️ ⭐️ ⭐️ ⭐️"
        label.font = .systemFont(ofSize: 16.0)
        label.textAlignment = .center
        return label
    }()
    
  
    init(_ viewModel: ProfileRequestReviewListViewModel){
        super.init(frame: .zero)
        
        setView()
        
        
        backgroundColor = viewModel.backgroundColor
        requestLabel.text = viewModel.title
        tapHandler = viewModel.tapHandler
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var emojiLabelLeadingConstraint: NSLayoutConstraint!
    private var starLabelTrailingConstraint: NSLayoutConstraint!
    
    private func setView(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tapGesture)
        
        backgroundColor = UIColor(hex: "")
        
        addSubview(emojiLabel)
        addSubview(requestLabel)
        addSubview(starLabel)
        
        emojiLabelLeadingConstraint = emojiLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        starLabelTrailingConstraint = starLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        
        NSLayoutConstraint.activate([
            emojiLabelLeadingConstraint,
            emojiLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            emojiLabel.heightAnchor.constraint(equalTo: heightAnchor, constant: -32.0),
            emojiLabel.widthAnchor.constraint(equalTo: emojiLabel.heightAnchor),
            
            requestLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.0),
            requestLabel.leadingAnchor.constraint(equalTo: starLabel.leadingAnchor),
            requestLabel.trailingAnchor.constraint(equalTo: starLabel.trailingAnchor),
            requestLabel.bottomAnchor.constraint(equalTo: starLabel.topAnchor, constant: -16.0),
            
            
            starLabel.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 16.0),
            starLabelTrailingConstraint,
            starLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.0)
        ])
    }
    

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let round = self.frame.height / 2
        
        self.roundCorners(round)
                
        emojiLabelLeadingConstraint.constant = round - 32.0
        starLabelTrailingConstraint.constant = -round
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.3) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.3) {
            self.transform = .identity
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.3) {
            self.transform = .identity
        }
    }
    
    
    @objc
    private func didTap(){
        tapHandler?()
    }
    
}
