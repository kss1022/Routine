//
//  AppInfoMainViewModel.swift
//  Routine
//
//  Created by 한현규 on 11/20/23.
//

import Foundation
import UIKit



struct AppInfoMainViewModel{
    let image: UIImage?
    let version: String
    let copyright: String
    
    init(_ model: AppInfoMainModel){
        self.image = UIImage(named: model.imageName)
        self.version = model.version
        self.copyright = model.copyright
    }
}
