//
//  TutorialListView.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import UIKit



final class TutorialRoutineListCell: UITableViewCell{
            
    private let cardView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8.0
        return stackView
    }()
    
    private let emojiView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32.0)
        return label
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .getFont(size: 28.0)
        label.textColor = .black
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setView(){
        backgroundColor = .clear
        
        cardView.backgroundColor = .white
        cardView.roundCorners()

        
        
        contentView.addSubview(cardView)
        cardView.addSubview(stackView)
        
        stackView.addArrangedSubview(emojiView)
        stackView.addArrangedSubview(titleLabel)

        
        
        
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24.0),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24.0),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0),
            
            stackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16.0),
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16.0),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16.0),
            stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16.0),
            
            emojiView.widthAnchor.constraint(equalTo: emojiView.heightAnchor),
        ])
    }

    
    func bindView(_ viewModel: TutorialRoutineListViewModel){
        emojiView.text = viewModel.emoji
        titleLabel.text = viewModel.title
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected{
            cardView.backgroundColor = UIColor(hex: "#82B1FFFF")
            cardView.layer.borderWidth = 3.0
            cardView.layer.borderColor = UIColor(hex: "#448AFFFF")?.cgColor                        
        }else{
            cardView.backgroundColor = .white
            cardView.layer.borderWidth = 0.0
            cardView.layer.borderColor = UIColor.clear.cgColor
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        cardView.backgroundColor = .white
        cardView.layer.borderWidth = 0.0
        cardView.layer.borderColor = UIColor.clear.cgColor

    }

    
    
    
}



extension TutorialRoutineListCell{

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.3) {
            self.cardView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.3) {
            self.cardView.transform = .identity
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.3) {
            self.cardView.transform = .identity
        }
    }
    
}
