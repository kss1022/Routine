//
//  KeychainAccess.swift
//  WelcomeKorea
//
//  Created by 한현규 on 2023/05/09.
//

import Foundation


let defaultKeychainService = "hg.Routine.keychain"

enum KeychainError: Error {
  case updateFailed(key: String, description: String)
  case insertFailed(key: String, description: String)
  case removeFailed(key: String, description: String)
}

/// 키 체인에 값을 저장하고 읽게 해주는 클래스.
/// 저장하기 위한 키는 Accout Key, 값은 Password 형태로 저장
public struct KeychainAccess {
  public static let shared = KeychainAccess(serviceName: defaultKeychainService)
  
  public let serviceName: String
  
  public func get(forAccountKey account: String) -> String? {
    let query = baseQueryDictionary()
    query[kSecReturnData] = true
    query[kSecMatchLimit] = kSecMatchLimitOne
    query[kSecAttrAccount] = account
    var queryResult: AnyObject?
    let readStatus = SecItemCopyMatching(query, &queryResult)
    if readStatus != errSecSuccess {
        Log.e("Failed to retrieve data for key: \(account). Reason: \(securityErrorMeesage(fromStatus: readStatus))")
      return nil
    }
    guard let passwordData = queryResult as? Data else {
        Log.e("Failed to convert query result to data")
      return nil
    }
    return String(data: passwordData, encoding: .utf8)
  }
  
  public func set(_ value: String?, forAccountKey account: String) throws {
    guard let value = value else {
      try removeValue(forAccountKey: account)
      return
    }
    
    if exists(forAccountKey: account) {
      try update(value, forAccountKey: account)
    } else {
      try insert(value, forAccountKey: account)
    }
  }
  
  public func exists(forAccountKey account: String) -> Bool {
    let query = baseQueryDictionary()
    query[kSecReturnData] = false
    query[kSecMatchLimit] = kSecMatchLimitOne
    query[kSecAttrAccount] = account
    let readStatus = SecItemCopyMatching(query, nil)
    if readStatus == errSecSuccess {
      return true
    }
    if readStatus != errSecItemNotFound {
        Log.e("Failed to query existence of key: \(account). Reason: \(securityErrorMeesage(fromStatus: readStatus))")
    }
    return false
  }

  public func removeValue(forAccountKey account: String) throws {
    let query = baseQueryDictionary()
    query[kSecAttrAccount] = account
    let deleteStatus = SecItemDelete(query)
    if deleteStatus != errSecSuccess {
      throw KeychainError.removeFailed(key: account, description: securityErrorMeesage(fromStatus: deleteStatus))
    }
  }
  
  public func removeAll() throws {
    let deleteStatus = SecItemDelete(baseQueryDictionary())
    if deleteStatus != errSecSuccess {
      throw KeychainError.removeFailed(key: "ALL", description: securityErrorMeesage(fromStatus: deleteStatus))
    }
  }

  /// 새로운 값을 저장
  private func insert(_ value: String, forAccountKey account: String) throws {
    let query = baseQueryDictionary()
    query[kSecValueData] = value.data(using: .utf8)
    query[kSecAttrAccount] = account
    let saveStatus = SecItemAdd(query, nil)
    if saveStatus != errSecSuccess {
      throw KeychainError.insertFailed(key: account, description: securityErrorMeesage(fromStatus: saveStatus))
    }
  }
  
  /// 기존 값을 수정
  private func update(_ value: String, forAccountKey account: String) throws {
    let query = baseQueryDictionary()
    query[kSecAttrAccount] = account
    let attributesToUpdate = [kSecValueData: value.data(using: .utf8)!] as NSDictionary
    let updateStatus = SecItemUpdate(query, attributesToUpdate)
    if updateStatus != errSecSuccess {
      throw KeychainError.updateFailed(key: account, description: securityErrorMeesage(fromStatus: updateStatus))
    }
  }

  private func baseQueryDictionary() -> NSMutableDictionary {
    return [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: serviceName,
      kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock] as NSMutableDictionary
  }

  /// Keychain에서 발생한 에러 상태값을 메시지로 변환
  private func securityErrorMeesage(fromStatus status: OSStatus) -> String {
    if #available(iOS 11.3, *), let errorMessage = SecCopyErrorMessageString(status, nil) {
      return errorMessage as String
    } else {
      return "error code: \(status)"
    }
  }
}
