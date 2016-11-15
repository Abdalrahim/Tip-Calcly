//
//  Currency.swift
//  Tip Calcly
//
//  Created by Abdalrahim Abdullah on 26/8/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation

struct Currency {
    let name: String
    let rate: Double
    
    init(name: String, rate: Double) {
        let index: String.Index = name.characters.index(name.startIndex, offsetBy: 3)
        
        self.name = name.substring(from: index)
        self.rate = rate
        
    }
}
