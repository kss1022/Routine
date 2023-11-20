//
//  ProfileCardViewController.swift
//  Routine
//
//  Created by 한현규 on 11/14/23.
//

import ModernRIBs
import UIKit

protocol ProfileCardPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class ProfileCardViewController: UIViewController, ProfileCardPresentable, ProfileCardViewControllable {

    weak var listener: ProfileCardPresentableListener?
    
    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.addShadowWithRoundedCorners()
        view.clipsToBounds = true
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let profileInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 8.0
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .getBoldFont(size: 24.0)
        label.textColor = .label
        return label
    }()
    
    private lazy var introductionTextView: PlaceholerTextView = {
        let textView = PlaceholerTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .getFont(size: 12.0)
        textView.textColor = .secondaryLabel
        textView.backgroundColor = .clear
        let inset: CGFloat = 0.0
        textView.textContainerInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        
        
        textView.placeholder = "Edit Your Introduction"
        textView.delegate = self
        
        return textView
    }()
    
    private let barcodeView: ProfileBarcodeView = {
        let view = ProfileBarcodeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    
    init(){
        super.init(nibName: nil, bundle: nil)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setLayout()
    }
    
    private func setLayout(){
        view.addSubview(cardView)
        
        cardView.addSubview(profileImageView)
        cardView.addSubview(profileInfoStackView)
        
        profileInfoStackView.addArrangedSubview(nameLabel)
        profileInfoStackView.addArrangedSubview(introductionTextView)
        profileInfoStackView.addArrangedSubview(barcodeView)
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: view.topAnchor, constant: inset),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset),
            
            profileImageView.topAnchor.constraint(equalTo: cardView.topAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 160.0),
            profileImageView.heightAnchor.constraint(equalToConstant: 210.0),
            profileImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            
            
            profileInfoStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: inset),
            profileInfoStackView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: inset),
            profileInfoStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -inset),
            profileInfoStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -inset),
            
            
            introductionTextView.heightAnchor.constraint(lessThanOrEqualToConstant: 150.0)
        ])

    }
    
    func setProfileCard(name: String, introduce: String , barcode: String){
        nameLabel.text = name
        introductionTextView.text = introduce        
        barcodeView.setBarcode(barcode: barcode)
        profileImageView.image = UIImage(named: "traveler")
    }
}



extension ProfileCardViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let textView = textView as? PlaceholerTextView{
            textView.didBeginEditing()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let textView = textView as? PlaceholerTextView{
            textView.didEndEditing()
        }
    }

}
