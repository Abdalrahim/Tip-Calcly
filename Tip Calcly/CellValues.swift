//
//  CellValues.swift
//  Tip Calcly
//
//  Created by Abdalrahim Abdullah on 15/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import UIKit

class CellValues {
    
    var perPersonTotal:Double
    var perPersonTip:Double
    var isCellLocked:Bool
    var isCellModified:Bool
    
    
    init(perPersonTotal:Double,perPersonTip:Double) {
        
        self.perPersonTotal = perPersonTotal
        self.perPersonTip   = perPersonTip
        
        isCellLocked = false
        isCellModified = false
    }
    
    
}

