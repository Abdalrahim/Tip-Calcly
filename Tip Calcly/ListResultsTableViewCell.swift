//
//  ListResultsTableView.swift
//  Tip Calcly
//
//  Created by Abdalrahim Abdullah on 12/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit

protocol TCTableViewCellProtocol:class  {
    
    func calcAndReload() -> Void
}


class ListResultsTableViewCell: UITableViewCell {
    
    //Pseudo code
    // user changes a tip value
    // the changed column  is noted
    // all the column values are recalculated
    // the column changed values are reset
    // the cells are reloaded
    
    @IBOutlet weak var totalAmount: UITextField!
    @IBOutlet weak var tipAmount: UITextField!
    @IBOutlet weak var canChangeValue: UISwitch!
    
    weak var delegate:TCTableViewCellProtocol?
    
    var oldTipAmount:Double?
    
    var myCellDetails:CellValues? {
        
        didSet{
            
            if let myCellDetails = myCellDetails{
                
                self.totalAmount.text = String(myCellDetails.perPersonTotal)
                self.tipAmount.text = String(myCellDetails.perPersonTip)
                
                if oldValue == nil {
                    
                    oldTipAmount = Double(tipAmount.text!)
                    tipAmount.addTarget(self, action: #selector(textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
                    
                }
            }
            
        }
        
    }
    
    func textFieldDidChange(textField: UITextField) {
        
        if let value = Double(textField.text!) {
            
            myCellDetails!.perPersonTip = value
            
        }
        else {
            myCellDetails?.perPersonTip = 0.0
        }
        
        myCellDetails!.isCellModified = true
        
        if canChangeValue.on == true {
            
            myCellDetails!.isCellLocked = false
            
        }
        else {
            
            myCellDetails!.isCellLocked = true
            
        }
        
        myCellDetails!.perPersonTotal = myCellDetails!.perPersonTotal - oldTipAmount! + myCellDetails!.perPersonTip
        
        oldTipAmount = myCellDetails!.perPersonTip
        
        if let delegate = delegate {
            
            delegate.calcAndReload()
        }
        
    }
    
}

