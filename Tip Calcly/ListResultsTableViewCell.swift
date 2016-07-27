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
    
    @IBAction func canChangeVal(sender: AnyObject) {
        print(canChangeValue.on)
    }
    
    
    weak var delegate:TCTableViewCellProtocol?
    
    var oldTotalAmount:Double?
    var oldTipAmount:Double?
    
    
    var myCellDetails:CellValues? {
        
        
        didSet{
            
            if let myCellDetails = myCellDetails{
                addDoneButtonOnKeyboard()
                
                self.totalAmount.text = String(myCellDetails.perPersonTotal)
                self.tipAmount.text = String(myCellDetails.perPersonTip)
                
                if oldValue == nil {
                    
                    oldTotalAmount = Double(totalAmount.text!)
                    totalAmount.addTarget(self, action: #selector(totalFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
                    
                    oldTipAmount = Double(tipAmount.text!)
                    tipAmount.addTarget(self, action: #selector(tipFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
                }
                
            }
            
        }
        
    }
    
    func totalFieldDidChange(textField: UITextField) {
        
        if let value = Double(textField.text!) {
            
            myCellDetails!.perPersonTotal = value
            
        }
        else {
            myCellDetails?.perPersonTotal = 0.0
        }
        
        myCellDetails!.isCellModified = true
        
        oldTotalAmount = myCellDetails!.perPersonTotal
        
        
    }
    
    //add calculate button
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Recalculate", style: UIBarButtonItemStyle.Done, target: self, action: #selector(doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.totalAmount.inputAccessoryView = doneToolbar
        self.tipAmount.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction()
    {
        self.totalAmount.resignFirstResponder()
        self.tipAmount.resignFirstResponder()
        if canChangeValue.on == true {
            if let delegate = delegate {
            
            delegate.calcAndReload()
            }
        }
        else {
            return
        }
    }
    
    func tipFieldDidChange(textField: UITextField) {
        
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
        
        
        oldTipAmount = myCellDetails!.perPersonTip
        
        
    }
}