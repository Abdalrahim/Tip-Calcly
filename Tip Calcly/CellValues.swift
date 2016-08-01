//
//  CellValues.swift
//  Tip Calcly
//
//  Created by Abdalrahim Abdullah on 15/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit

class CellValues {
    
    var perPersonTotal:Double //excludes the tip amount
    var perPersonTip:Double
    var isCellLocked:Bool     // this happens when a cell amount is changed
    
    
    
    init(perPersonTotal:Double,perPersonTip:Double) {
        
        self.perPersonTotal = perPersonTotal
        self.perPersonTip   = perPersonTip
        
        isCellLocked = false
        
    }
    
    
}

