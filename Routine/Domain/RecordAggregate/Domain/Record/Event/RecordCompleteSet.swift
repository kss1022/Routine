//
//  RecordCompleteSet.swift
//  Routine
//
//  Created by 한현규 on 10/12/23.
//

import Foundation



final class RecordCompleteSet: DomainEvent{
    let recordId: RecordId
    let isComplete: Bool
    
    init(recordId: RecordId,isComplete: Bool) {
        self.recordId = recordId
        self.isComplete = isComplete
        super.init()
    }
    
    
    override func encode(with coder: NSCoder) {
        recordId.encode(with: coder)
        coder.encodeBool(isComplete, forKey: CodingKeys.isComplete.rawValue)
        super.encode(with: coder)
    }
    
    override init?(coder: NSCoder) {
        guard let recordId = RecordId(coder: coder)
        else { return nil }
        
        self.recordId = recordId
        self.isComplete = coder.decodeBool(forKey: CodingKeys.isComplete.rawValue)
        super.init(coder: coder)
    }
    
    private enum CodingKeys: String{
        case isComplete
    }
    
    static var supportsSecureCoding: Bool = true
    
}
