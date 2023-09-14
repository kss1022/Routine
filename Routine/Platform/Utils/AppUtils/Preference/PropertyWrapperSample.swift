//
//  PropertyWrapperSample.swift
//  WelcomeKorea
//
//  Created by 한현규 on 2023/05/09.
//

import Foundation

/**
 * 하지만, 아무데나 갖다 붙일 수 있기 때문에 여러 클래스에 프로퍼티 정의가 분산될 경우 일관성을 잃을 수
 *  있고, UserDefaults.standard 이외의 suite를 별도 지정하기가 힘들다는 문제가 있기 때문에 팀 단위에서
 *   사용하기엔 무리가 있음
 */

@propertyWrapper
struct UserDefault<Value> {
  let key: String
  let defaultValue: Value

  var wrappedValue: Value {
    get {
      return UserDefaults.standard.object(forKey: key) as? Value ?? defaultValue
    }
    set {
      UserDefaults.standard.set(newValue, forKey: key)
    }
  }
}
extension UserDefault where Value == Bool {
  init(key: String) {
    self.init(key: key, defaultValue: false)
  }
}
extension UserDefault where Value: ExpressibleByIntegerLiteral {
  init(key: String) {
    self.init(key: key, defaultValue: 0)
  }
}
extension UserDefault where Value == String {
  init(key: String) {
    self.init(key: key, defaultValue: "")
  }
}

@propertyWrapper
struct Keychain {
  let key: String
  let defaultValue: String
  
  var wrappedValue: String {
    get {
      return KeychainAccess.shared.get(forAccountKey: key) ?? defaultValue
    }
    set {
      do {
        try KeychainAccess.shared.set(newValue, forAccountKey: key)
      } catch {
          Log.e(error.localizedDescription)
      }
    }
  }
}
extension Keychain {
  init(key: String) {
    self.init(key: key, defaultValue: "")
  }
}

// 사용 예
enum GlobalSettings {
  @UserDefault(key: "testTerms")
  static var termsAgreed: Bool
  
  @UserDefault(key: "testTutorial", defaultValue: false)
  static var showsTutorial: Bool
  
  @Keychain(key: "testPassword")
  static var password: String
}

