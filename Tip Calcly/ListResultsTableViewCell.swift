//
//  ListResultsTableView.swift
//  Tip Calcly
//
//  Created by Abdalrahim Abdullah on 12/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding


protocol TCTableViewCellProtocol:class  {
    
    func calcAndReload() -> Void
    func keyboardWillShow(notification: Notification) -> Void
    func keyboardWillHide(notification: Notification) -> Void
}

class ListResultsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var personLabel: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var tipAmount: UILabel!
    @IBOutlet weak var totalAmount: UITextField!
    @IBOutlet weak var rowIsLocked: UISwitch!
    weak var delegate:TCTableViewCellProtocol?
    var oldAmountValue:Double!
    
    var myCellDetails:CellValues? {
        
        didSet{
            
            if let myCellDetails = myCellDetails{
                self.amount.text = String(format: "%.2f", myCellDetails.perPersonTotal)
                self.tipAmount.text = String(format: "%.2f", myCellDetails.perPersonTip)
                self.totalAmount.text = String(format: "%.2f", myCellDetails.perPersonTip + myCellDetails.perPersonTotal)
                
                oldAmountValue = Double(self.totalAmount.text!)
                if myCellDetails.isCellLocked {
                    
                    rowIsLocked.setOn(true, animated: false)
                    rowIsLocked.onImage = #imageLiteral(resourceName: "Lock")
                    rowIsLocked.offImage = #imageLiteral(resourceName: "Unlock")
                    //totalAmount.backgroundColor = UIColor.redColor()
                    
                } else {
                    
                    if rowIsLocked.isOn{
                        
                        rowIsLocked.setOn(false, animated: false)
                        
                    }
                }
                
                if oldValue == nil {
                    
                    //assumption that this will be triggered the first time only
                    totalAmount.addTarget(self, action: #selector(totalAmountDidChange(textField:)), for: UIControlEvents.editingDidEnd)
                    
                    TCHelperClass.addDoneButtonOnKeyboard(sendingVC: self, sendingTextFld: totalAmount)
                    
                    
                    
                }
                //Checks if the the split is negative and warns the user
                if Double(totalAmount.text!)! < 0{
                    totalAmount.backgroundColor = UIColor.red
                    totalAmount.textColor = UIColor.white
                }
                else if Double(totalAmount.text!)! >= 0{
                    totalAmount.backgroundColor = UIColor.white
                    totalAmount.textColor = UIColor.purple
                }
            }
            
        }
        
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    
    @IBAction func sliderDidChange(sender: AnyObject) {
        
        rowIsLocked.onImage = #imageLiteral(resourceName: "Lock")
        rowIsLocked.offImage = #imageLiteral(resourceName: "Unlock")
        
        if rowIsLocked.isOn {
            
            myCellDetails?.isCellLocked = true
        }
        else {
            myCellDetails?.isCellLocked = false
        }
    }
    
    @IBAction func change(_ sender: Any) {
        if let changedAmountValue = Double(totalAmount.text!) {
            
            // only if the new value is different from the old one
            if ( oldAmountValue != changedAmountValue) {
                (myCellDetails!.perPersonTip,myCellDetails!.perPersonTotal) = TCHelperClass.recalcTipAndAmountValues(totalAmount: changedAmountValue)
                // trigger both the UI component and the cell value
                // surely there is a better way to do this...
                rowIsLocked.setOn(true, animated: true)
                myCellDetails?.isCellLocked = true
                
                if let delegate = delegate {
                    
                    delegate.calcAndReload()
                }
                
                oldAmountValue = changedAmountValue
                
            }
        }
    }
    
    
    func totalAmountDidChange(textField: UITextField) {
        
        if let changedAmountValue = Double(textField.text!) {
            
            // only if the new value is different from the old one
            if ( oldAmountValue != changedAmountValue) {
                (myCellDetails!.perPersonTip,myCellDetails!.perPersonTotal) = TCHelperClass.recalcTipAndAmountValues(totalAmount: changedAmountValue)
                // trigger both the UI component and the cell value
                // surely there is a better way to do this...
                rowIsLocked.setOn(true, animated: true)
                myCellDetails?.isCellLocked = true
                
                if let delegate = delegate {
                    
                    delegate.calcAndReload()
                }
                
                oldAmountValue = changedAmountValue
                
            }
        }
    }
}

extension ListResultsTableViewCell {
    
    
    func doneButtonAction()
    {
        self.totalAmount.resignFirstResponder()
    }
    
    
}
