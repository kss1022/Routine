//
//  ValueObject.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import Foundation


protocol ValueObject : Equatable{    
    func encode(with coder: NSCoder)
    init?(coder: NSCoder)
}

