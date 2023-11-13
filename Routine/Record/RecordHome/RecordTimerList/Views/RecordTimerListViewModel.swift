//
//  RecordTimerListViewModel.swift
//  Routine
//
//  Created by 한현규 on 11/9/23.
//

import Foundation




struct RecordTimerListViewModel: Hashable{
    let timerId: UUID
    let name: String
    let emojiIcon: String
    let duration: String
    let done: Bool
}
