//
//  TutorialRoutineListViewModel.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import Foundation



struct TutorialRoutineListViewModel: Hashable{
    let emoji: String
    let title: String
    
    init(_ model: CreateRoutineModel) {
        self.emoji = model.emoji
        self.title = model.name
    }
}
