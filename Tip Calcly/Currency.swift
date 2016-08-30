//
//  Currency.swift
//  Tip Calcly
//
//  Created by Abdalrahim Abdullah on 26/8/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Currency {
    let name: String
    let rate: Double
    
    init(name: String, rate: Double) {
        let index: String.Index = name.startIndex.advancedBy(3)
        
        self.name = name.substringFromIndex(index)
        self.rate = rate
        
    }
}