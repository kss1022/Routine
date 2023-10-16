//
//  SystemError.swift
//  Routine
//
//  Created by 한현규 on 10/13/23.
//

import Foundation




class SystemException: Error{
    var message: String
    
    init(_ message: String) {
        self.message = message
    }
    
    init(_ predicateFormat: String, _ args: CVarArg...) {
        self.message = String(format: predicateFormat, [args])
    }
}


//인수의 형식이 올바르지 않거나 합성 서식 문자열이 잘못 만들어진 경우 예외가 throw됩니다.
class FormatException : SystemException{

}

//메서드 호출이 개체의 현재 상태에 대해 유효하지 않을 때 throw되는 예외입니다.
class InvalidOperationException : SystemException{

}

//잘못된 캐스팅 또는 명시적 변환에 대해 throw되는 예외입니다.
class InvalidCastException: SystemException{

}

//메서드에 제공된 인수 중 하나가 유효하지 않을 때 throw되는 예외입니다.
class ArgumentException : SystemException{

}




