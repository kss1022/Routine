//
//  AppTypefaceListModel.swift
//  Routine
//
//  Created by 한현규 on 11/20/23.
//

import Foundation



struct AppTypefaceListModel{
    let title: String
    let isSelected: Bool
    let imageName: String
    let selectedImageName: String
    let tapHandler: () -> Void
}
