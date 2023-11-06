//
//  TimerRecordDto.swift
//  Routine
//
//  Created by 한현규 on 11/1/23.
//

import Foundation


public struct TimerRecordDto{
    public let timerId: UUID
    public let recordId: UUID
    public let recordDate: String
    public let startAt: Date
    public let endAt: Date?
    public let duration: Double?
}
