//
//  ProfileId.swift
//  Routine
//
//  Created by 한현규 on 11/23/23.
//

import Foundation


struct ProfileId : ValueObject{
    let id: UUID
    
    init(_ id: UUID) {
        self.id = id
    }

    
    func encode(with coder: NSCoder) {
        coder.encodeUUID(id, forKey: CodingKeys.id.rawValue)
    }
        
    init?(coder: NSCoder) {
        guard let uuid = coder.decodeUUID(forKey: CodingKeys.id.rawValue) else { return nil}
        self.id = uuid
        
    }
        
    private enum CodingKeys: String {
        case id = "ProfileId"
    }
}
