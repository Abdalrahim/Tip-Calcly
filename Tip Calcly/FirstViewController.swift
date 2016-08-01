//
//  FirstViewController.swift
//  Tip Calcly
//
//  Created by Abdalrahim Abdullah on 11/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Mixpanel
import UIKit

class FirstViewController:  UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var numGuests: UITextField!
    @IBOutlet weak var tipPercent: UITextField!
    @IBOutlet weak var billAmount: UITextField!
    
    @IBOutlet weak var totalToPay: UITextField!
    @IBOutlet weak var totalTipToPay: UITextField!
    @IBOutlet weak var totalPerPerson: UITextField!
    @IBOutlet weak var tipPerPerson: UITextField!
    
    var numGuestpickerView:UIPickerView!
    var tipPercentpickerView:UIPickerView!
    
    @IBAction func doCalculate(sender: AnyObject) {
        Mixpanel.sharedInstance().track("Equal Calculated")
        calculateResults()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        TCHelperClass.isFirstVC = true
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        Mixpanel.sharedInstance().track("Equal Share Opened")
        
        //initially hide Results
        bottomView.alpha = 0
        
        //Set Master Data
        CellData.setGuestValues()
        CellData.setTipValues()
        //hideKeyboardWhenTappedAround()
        //Text Field Delegates
        numGuests.delegate = self
        tipPercent.delegate = self
        
        //Picker View
        numGuestpickerView = UIPickerView()
        numGuestpickerView.delegate = self
        numGuestpickerView.backgroundColor = CellData.pickerBkgColor
        
        
        tipPercentpickerView = UIPickerView()
        tipPercentpickerView.delegate = self
        tipPercentpickerView.backgroundColor = CellData.pickerBkgColor
        
        numGuests.inputView = numGuestpickerView
        tipPercent.inputView = tipPercentpickerView
        
        // Done button on keyboard
        TCHelperClass.addDoneButtonOnKeyboard(self, sendingTextFld: billAmount)
        
        //Tap gesture recognizer to dismiss Keyboard and Picker View
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    
    
    func calculateResults() {
        
        //resign first responder
        dismissKeyboard()
        
        //calculate results only if key values are populated
        if let numGuests = CellData.guest_to_num_converter[numGuests.text!],
            tipPercent = CellData.tip_to_num_converter[tipPercent.text!],
            billAmount = Double(billAmount.text!){
            
            TCHelperClass.billAmount = billAmount
            TCHelperClass.numGuests = numGuests
            TCHelperClass.tipPercent = tipPercent
            
            totalTipToPay.text = String(format: "%.2f", TCHelperClass.getTotalTip())
            
            totalToPay.text =  String(format: "%.2f", billAmount + TCHelperClass.getTotalTip())
            
            tipPerPerson.text = String(format: "%.2f", TCHelperClass.getPerPersonTip() )
            
            totalPerPerson.text = String(format: "%.2f", TCHelperClass.getPerPersonAmount() + TCHelperClass.getPerPersonTip())
            
            
            //show the results if bottom view is hidden
            if self.bottomView.alpha == 0.0 {
                UIView.animateWithDuration(CellData.animationDuration) {
                    self.bottomView.alpha = 1.0
                }
            }
            
        } else {
            
            // make all key fields blank
            numGuests.text = ""
            tipPercent.text = ""
            billAmount.text = ""
            
            //hide the bottom view
            if self.bottomView.alpha == 1.0 {
                
                UIView.animateWithDuration(CellData.animationDuration) {
                    self.bottomView.alpha = 0.0
                }
                
            }
            
        }
        
        
    }
    
    
}

// MARK: Resign first responder Logic
extension FirstViewController{
    
    func doneButtonAction()
    {
        billAmount.resignFirstResponder()
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
}

// MARK: Picker View logic
extension FirstViewController{
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        //For example, if you wanted to do a picker for selecting time,
        //you might have 3 components; one for each of hour, minutes and seconds
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == numGuestpickerView{
            
            return CellData.guests.count
        }
        else {
            return CellData.tips.count
        }
        
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == numGuestpickerView{
            
            return CellData.guests[row]
        }
        else {
            
            return CellData.tips[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        pickerView.reloadAllComponents()
        
        if pickerView == numGuestpickerView{
            
            numGuests.text = CellData.guests[row]
            
        } else {
            
            tipPercent.text =  CellData.tips[row]
        }
        
        
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let color = (row == pickerView.selectedRowInComponent(component)) ? UIColor.whiteColor() : UIColor.grayColor()
        
        if pickerView == numGuestpickerView{
            return NSAttributedString(string: CellData.guests[row], attributes: [NSForegroundColorAttributeName: color])
        } else {
            return NSAttributedString(string: CellData.tips[row], attributes: [NSForegroundColorAttributeName: color])
        }
    }
    
    
    
}

//MARK: UITextFieldDelegate implementation
extension FirstViewController {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField.text == "" {
            
            if textField == numGuests {
                
                numGuests.text = CellData.guests[numGuestpickerView.selectedRowInComponent(0)]
                
            }
            if textField == tipPercent {
                
                tipPercent .text = CellData.tips[tipPercentpickerView.selectedRowInComponent(0)]
            }
        }
        
        
    }
    
}