//
//  ProfileStyleViewModel.swift
//  Routine
//
//  Created by 한현규 on 11/24/23.
//

import Foundation
import UIKit.UIColor


struct ProfileStyleViewModel{
    let topColor: CGColor?
    let bottomColor: CGColor?
    
    init(_ model: ProfileStyleModel) {
        self.topColor = UIColor(hex: model.topColor)?.cgColor
        self.bottomColor = UIColor(hex: model.bottomColor)?.cgColor
    }
}
