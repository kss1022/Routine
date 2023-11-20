//
//  OsTypefaceListModel.swift
//  Routine
//
//  Created by 한현규 on 11/20/23.
//

import Foundation



struct OsTypefaceListModel{    
    let isSelected: Bool
    let fontName: String?
    let imageName: String
    let selectedImageName: String
    let tapHandler: () -> Void
}
