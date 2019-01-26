//
//  Ticker.swift
//  BitPoloniex
//
//  Created by Saleh on 1/25/19.
//  Copyright © 2019 Saleh. All rights reserved.
//

import Foundation

/*
 
 [ <id>, null, [ <currency pair id>, "<last trade price>", "<lowest ask>", "<highest bid>", "<percent change in last 24 hours>", "<base currency volume in last 24 hours>", "<quote currency volume in last 24 hours>", <is frozen>, "<highest trade price in last 24 hours>", "<lowest trade price in last 24 hours>" ], ... ]
 
 */

struct Ticker {
    
    var pairId: Int?
    var name: String?
    var lastTradePrice: Double?
    var lowestRisk: Double?
    var highestBid: Double?
    
    init() { }
    
    init(values:[Any]) {
        self.pairId = values[0] as? Int;
        self.lastTradePrice = Double((values[1] as? String) ?? "")
        self.lowestRisk = Double((values[2] as? String) ?? "")
        self.highestBid = Double((values[3] as? String) ?? "")
    }
    
    init(idAndName dictionary:Dictionary<String, String>) {
        self.pairId = Int(dictionary["id"] ?? "")
        self.name = dictionary["name"]
    }
    
}
