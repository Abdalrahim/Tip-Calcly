//
//  TCHelperClass.swift
//  Tip Calcly
//
//  Created by Abdalrahim Abdullah on 14/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import UIKit

class TCHelperClass {
    
    var allXRArray :[Currency] = []
    
    static var isFirstVC:Bool = true
    
    static var billAmount:Double? {
        didSet {
            
            if isFirstVC == false {
                setInitialCellValues()
                
            }
        }
    }
    
    static var numGuests:Int? {
        didSet {
            
            if isFirstVC == false {
                setInitialCellValues()
            }
        }
    }
    
    static var tipPercent:Double? {
        didSet {
            
            if isFirstVC == false {
                setInitialCellValues()
            }
        }
    }
    
    
    static var tcCellValues:[CellValues]?
    
    
    static func getTotalTip() -> Double{
        
        if let billAmount = billAmount, let tipPercent = tipPercent {
            return round( billAmount * tipPercent / 100 * 1000 ) / 1000
            
        }
        
        return 0.0
    }
    
    
    static func getPerPersonTip() -> Double{
        
        if let numGuests = numGuests {
            return round( TCHelperClass.getTotalTip() / Double(numGuests) * 1000 ) / 1000
        }
        
        return 0.0
    }
    
    
    static func getPerPersonAmount() -> Double{
        
        if let numGuests = numGuests , let billAmount = billAmount {
            return round( billAmount / Double(numGuests) * 1000 ) / 1000
        }
        
        return 0.0
    }
    
    
    static func setInitialCellValues() -> Void {
        
        if let _ = billAmount,let numGuests = numGuests,let _ = tipPercent{
            
            tcCellValues = [] // some redundancy will happen here
            
            //initialize only if second VC is active
            if isFirstVC == false{
                for _ in 0..<numGuests {
                    tcCellValues?.append(CellValues(perPersonTotal: TCHelperClass.getPerPersonAmount(), perPersonTip: TCHelperClass.getPerPersonTip()))
                }
            }
        }
        
        
    }
    
    static func resetCellValues() -> Void {
        
        var tips:Double = 0.0
        var total:Double = 0.0
        
        var counter = 0
        
        //get modified tips and amounts
        for tcCellValue in tcCellValues!  {
            
            if tcCellValue.isCellLocked {
                
                tips += tcCellValue.perPersonTip
                total += tcCellValue.perPersonTotal
                
                counter = counter + 1
            }
            
        }
        // do this only if there are some guests
        // whose total amount is not modified
        if ( numGuests! - counter ) > 0 {
            
            let perPersonTip =    round ( ( TCHelperClass.getTotalTip() - tips ) / Double( numGuests! - counter ) * 1000 ) / 1000
            
            let perPersonAmount =    round ( ( billAmount! - total ) / Double( numGuests! - counter ) * 1000 ) / 1000
            
            for tcCellValue in tcCellValues!  {
                
                if ( !tcCellValue.isCellLocked)  {
                    
                    tcCellValue.perPersonTip = perPersonTip
                    tcCellValue.perPersonTotal = perPersonAmount
                    
                }
                
            }
            
            
            
        }
        
        
    }
    
    static func recalcTipAndAmountValues(totalAmount:Double) -> (Double,Double) {
        
        if let tipPercent = tipPercent {
            
            let amount =  round ( ( totalAmount / (1 + tipPercent/100) ) * 1000 ) / 1000
            let tipAmount = round ( amount * tipPercent * 10) / 1000
            
            
            return (tipAmount,amount)
        }
        
        return (0.0,0.0)
    }
    
    /*
     * http://stackoverflow.com/questions/35689528/add-a-view-on-top-of-the-keyboard
     * using-inputaccessoryview-swift
     */
    static func addDoneButtonOnKeyboard(sendingVC:AnyObject,sendingTextFld:UITextField){
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.black
        
        doneToolbar.barTintColor = CellData.pickerBkgColor
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: sendingVC, action: #selector(doneButtonAction))
        
        done.tintColor = UIColor.white
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        sendingTextFld.inputAccessoryView = doneToolbar
        
    }
    
    @objc static func doneButtonAction()
    {
        print("Dummy: Not used")
        
    }
    
    
}
