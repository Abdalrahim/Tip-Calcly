//
//  slider.swift
//  Tip Calcly
//
//  Created by Abdalrahim Abdullah on 14/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import UIKit

class TCHelperClass {
    
    static let numGuestOptions = ["1","2","3","4","5","6","7","8","9","10...50"]
    static let tipPercentOptions = ["0","5","10","15","20"]
    
    static var billAmount:Double? {
        didSet {
            setInitialCellValues()
        }
    }
    static var numGuests:Int? {
        didSet {
            setInitialCellValues()
        }
    }
    
    static var tipPercent:Double? {
        didSet {
            setInitialCellValues()
        }
    }
    
    static var tcCellValues:[CellValues]?
    
    static func setInitialCellValues() -> Void {
        
        if let billAmount = billAmount,numGuests = numGuests,tipPercent = tipPercent{
            
            let perPersonAmount = round(100 * (billAmount / Double(numGuests)) ) / 100
            let perPersonTipAmount =  round(tipPercent * perPersonAmount / 100  * 100)/100
            let totalPerPersonAmount = round( (perPersonAmount + perPersonTipAmount) * 100 ) / 100
            
            tcCellValues = [CellValues]()
            
            for _ in 0..<numGuests {
                tcCellValues?.append(CellValues(perPersonTotal: totalPerPersonAmount, perPersonTip: perPersonTipAmount))
            }
        }
        
        
    }
    
    static func seCellValues() -> Void {
        
        var tips:Double = 0.0
        var total:Double = 0.0
        
        var counter = 0
        
        //get modified tips and amounts
        for tcCellValue in tcCellValues!  {
            
            if tcCellValue.isCellModified {
                
                tips += tcCellValue.perPersonTip
                total += tcCellValue.perPersonTotal
                
                counter = counter + 1
            }
            
        }
        if ( numGuests! - counter ) > 0 {
            //calculate the tips and amounts for the non modified
            let totalTip = round( tipPercent! / 100 * billAmount! * 100) / 100
            let totalAmount =  round ((totalTip + billAmount!) * 100 ) / 100
            
            let perPersonTip =    round ( ( totalTip - tips ) / Double( numGuests! - counter ) * 100 ) / 100
            let perPersonAmount =    round ( ( totalAmount - total ) / Double( numGuests! - counter ) * 100 ) / 100
            
            
            for tcCellValue in tcCellValues!  {
                
                if !tcCellValue.isCellModified {
                    
                    tcCellValue.perPersonTip = perPersonTip
                    tcCellValue.perPersonTotal = perPersonAmount
                    
                }
                
            }
            
            for tcCellValue in tcCellValues!  {
                
                if tcCellValue.isCellModified {
                    
                    tcCellValue.isCellModified = false
                    
                }
                
            }
            
        }
        
        
    }
    
}