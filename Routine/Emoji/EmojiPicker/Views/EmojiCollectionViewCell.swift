//
//  EmojiCollectionViewCell.swift
//  Routine
//
//  Created by 한현규 on 12/1/23.
//


import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private Properties
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSelectedBackgroundView()
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    public func setEmoji(with emoji: String) {
        emojiLabel.text = emoji
    }
    
    // MARK: - Private Methods
    
    private func setView() {
        contentView.addSubview(emojiLabel)
        NSLayoutConstraint.activate([
            emojiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emojiLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emojiLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            emojiLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupSelectedBackgroundView() {
        let selectedView = UIView()
        selectedView.backgroundColor = .selectedCellBackgroundViewColor
        selectedView.clipsToBounds = true
        
        if #available(iOS 13.0, *) {
            selectedView.layer.cornerCurve = .continuous
        }
        
        selectedView.layer.cornerRadius = 8
        selectedBackgroundView = selectedView
    }
}
