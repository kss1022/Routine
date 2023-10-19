//
//  CreatTimerViewModel.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import Foundation
import UIKit.UIImage


struct CreatTimerViewModel{
    let title: String
    let description: String
    let image: UIImage?
    let tapHandler: () -> Void
    
    
    init(_ model: CreateTimerModel) {
        self.title = model.title
        self.description = model.description
        self.image = UIImage(named: model.imageName)
        self.tapHandler = model.tapHandler
    }
}
