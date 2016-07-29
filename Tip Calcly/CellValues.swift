//
//  CellValues.swift
//  Tip Calcly
//
//  Created by Abdalrahim Abdullah on 15/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit

class CellValues {
    
    var perPersonTotal:Double
    var perPersonTip:Double
    var isCellLocked:Bool
    var isCellModified:Bool
    
    
    init( perPersonTotal:Double, perPersonTip:Double, isCellLocked:Bool) {
        
        self.perPersonTotal = perPersonTotal
        self.perPersonTip   = perPersonTip
        
        self.isCellLocked = isCellLocked
        isCellModified = false
    }
    
    
}

