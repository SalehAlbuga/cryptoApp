//
//  AppUserDefaults.swift
//  BitPoloniex
//
//  Created by Saleh on 1/26/19.
//  Copyright © 2019 Saleh. All rights reserved.
//

import Foundation

struct AppUserDefaults {
    
    enum UserDefaultsKeys:String {
        case user = "user"
        case isLoggedIn = "isLoggedIn"
    }
    
    static func set(user:User?){
        if user != nil  {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(user), forKey: UserDefaultsKeys.user.rawValue)
        } else {
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.user.rawValue)
        }
    }
    
    static func getUser() -> User? {
        if let data = UserDefaults.standard.value(forKey:UserDefaultsKeys.user.rawValue) as? Data {
            let user = try? PropertyListDecoder().decode(User.self, from: data)
            return user
        } else {
            return nil
        }
    }

}
