//
//  RoutineEditStyleViewController.swift
//  Routine
//
//  Created by 한현규 on 11/30/23.
//

import ModernRIBs
import UIKit

protocol RoutineEditStylePresentableListener: AnyObject {
    func didSetStyle(style: EmojiStyle)
}

final class RoutineEditStyleViewController: UIViewController, RoutineEditStylePresentable, RoutineEditStyleViewControllable {

    weak var listener: RoutineEditStylePresentableListener?
    
    
    private lazy var collectionView : EmojiStyleCollectionView = {
        let collectionView = EmojiStyleCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.tapHandler = { [weak self] style in
            self?.listener?.didSetStyle(style: style)
        }
        return collectionView
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
        view.backgroundColor = .secondarySystemBackground
        
        view.addSubview(collectionView)
                        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        
    }
        
    
    func setStyle(style: EmojiStyle) {
        collectionView.setStyle(style: style)
    }
    
    


}

