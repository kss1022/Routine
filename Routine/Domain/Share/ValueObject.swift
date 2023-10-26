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


protocol EncodedValueObject{
    associatedtype Encoder: EncodableValueObject
    
    var encoder: Encoder { get }
    var encodedKey: String{ get }
}


typealias EncodableValueObject = NSObject & NSCoding & NSSecureCoding


extension Array where Element: EncodableValueObject {
    func encode(with coder: NSCoder) {
        coder.encode(self, forKey: "\(Element.self)")
    }
    
    static func decode(coder: NSCoder) -> [Element]? {
        return coder.decodeArrayOfObjects(ofClass: Element.self, forKey: "\(Element.self)")
    }
}


//extension Array where Element: EncodableValueObject? {
//    func encode(with coder: NSCoder) {
//        coder.encode(self, forKey: "\(Element.self)")
//    }
//    
//    static func decode(coder: NSCoder) -> [Element]? {
//        return coder.decodeArrayOfObjects(ofClass: Element.self, forKey: "\(Element.self)")
//    }
//}
