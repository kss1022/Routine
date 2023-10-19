//
//  CreateTimerModel.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import Foundation



struct CreateTimerModel{
    let title: String
    let description: String
    let imageName: String
    let timerType: AddTimerType
    let tapHandler: () -> Void    
}
