//
//  User.swift
//  BitPoloniex
//
//  Created by Saleh on 1/26/19.
//  Copyright © 2019 Saleh. All rights reserved.
//

import Foundation

struct User:Codable {
  
    var fullName: String?
    var email: String?
    var password: String?

    
    enum CodingKeys:String,CodingKey {
        case fullName = "fullName"
        case email = "email"
        case password = "password"
    }
    
    
}
