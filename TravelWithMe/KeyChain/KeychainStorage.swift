//
//  KeychainStorage.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/27.
//

import Foundation
import SwiftKeychainWrapper


private struct KeychainTokens {
    static let accessTokenKey: String = "Sub.AccessToken.Key"
    static let refreshTokenKey: String = "Sub.RefreshToken.Key"
}

final class KeychainStorage {
    
    static let shared = KeychainStorage()
    private init() { }
    
    
    var accessToken: String? {
        get {
            KeychainWrapper.standard.string(forKey: KeychainTokens.accessTokenKey)
        }
        set {
            if let value = newValue {
                KeychainWrapper.standard.set(value, forKey: KeychainTokens.accessTokenKey)
            } else {
                KeychainWrapper.standard.removeObject(forKey: KeychainTokens.accessTokenKey)
            }
        }
    }
    
    var refreshToken: String? {
        get {
            KeychainWrapper.standard.string(forKey: KeychainTokens.refreshTokenKey)
        }
        set {
            if let value = newValue {
                KeychainWrapper.standard.set(value, forKey: KeychainTokens.refreshTokenKey)
            }
            else {
                KeychainWrapper.standard.removeObject(forKey: KeychainTokens.refreshTokenKey)
            }
        }
    }
    
    func removeAllKeys() {
        KeychainWrapper.standard.removeAllKeys()
    }
    
    func printTokens() {
        let a = accessToken ?? "저장된 액세스 토큰이 없습니다"
        let b = refreshToken ?? "저장된 리푸레시 토큰이 없습니다"
        
        print("엑세스 토큰 : ", a)
        print("리푸레시 토큰 : ", b)
    }
}
