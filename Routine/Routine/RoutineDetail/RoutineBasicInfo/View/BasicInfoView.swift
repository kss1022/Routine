//
//  BasicInfoView.swift
//  Routine
//
//  Created by 한현규 on 10/12/23.
//

import UIKit



final class BasicInfoView: UIView {
    
    private var image: UIImage?


    private var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setFont(style: .headline)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()
    

    init(){
        super.init(frame: .zero)
        setView()
    }
        
    
    init(image: UIImage?, title: String){
        super.init(frame: .zero)
        
        setView()
        
        
        self.image = image
        self.label.attributedText = title.getAttributeImageString(
            image: image ?? UIImage(),
            font: .getFont(style: .headline)
        )
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setView()
    }
    
    private func setView(){
        self.backgroundColor = .systemBackground
        
        addSubview(label)
        roundCorners()
                
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset),
        ])
        
        
    }

    
    func setImage(_ image: UIImage?){
        self.image = image
    }
    
    func setTitle(_ title: String){
        self.label.text = title
                
        self.label.attributedText = title.getAttributeImageString(
            image: image ?? UIImage(),
            font: .getFont(style: .headline)
        )
    }
    
}
