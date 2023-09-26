//
//  RoutineCommands.swift
//  Routine
//
//  Created by 한현규 on 2023/09/18.
//

import Foundation



struct CreateRoutine : Command{
    let name: String
    let description: String
    let icon: String
    let tint: String
    let createCheckLists: [CreateCheckList]
}
