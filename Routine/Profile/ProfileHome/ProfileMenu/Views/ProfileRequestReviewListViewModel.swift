//
//  ProfileRequestReviewListViewModel.swift
//  Routine
//
//  Created by 한현규 on 11/23/23.
//

import Foundation
import UIKit.UIColor



struct ProfileRequestReviewListViewModel{
    let title: String
    let backgroundColor: UIColor?
    let tapHandler: () -> Void
    
    init(_ model: ProfileRequestReviewListModel) {
        self.title = model.title
        self.backgroundColor = UIColor(hex: model.backgroundColor)
        self.tapHandler = model.tapHandler
    }
}
