//
//  AppTypefaceListViewModel.swift
//  Routine
//
//  Created by 한현규 on 11/20/23.
//

import Foundation
import UIKit.UIImage


struct AppTypefaceListViewModel{
    let title: String
    let image: UIImage?
    let tapHandler: () -> Void

    
    init(_ model: AppTypefaceListModel) {
        self.title = model.title
        self.image = model.isSelected ?  UIImage(systemName: model.selectedImageName) : UIImage(systemName: model.imageName)
        self.tapHandler = model.tapHandler
    }
}
