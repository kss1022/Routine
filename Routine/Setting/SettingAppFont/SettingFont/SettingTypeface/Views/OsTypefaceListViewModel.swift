//
//  OsTypefaceViewModel.swift
//  Routine
//
//  Created by 한현규 on 11/20/23.
//

import Foundation
import UIKit.UIImage


struct OsTypefaceListViewModel{
    let fontName: String?
    let image: UIImage?
    let tapHandler: () -> Void

    
    init(_ model: OsTypefaceListModel) {        
        self.fontName = model.fontName
        self.image = model.isSelected ?  UIImage(systemName: model.selectedImageName) : UIImage(systemName: model.imageName)
        self.tapHandler = model.tapHandler
    }
}
