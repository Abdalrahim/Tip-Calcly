//
//  SecondViewController.swift
//  Tip Calcly
//
//  Created by Abdalrahim Abdullah on 11/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding
import Mixpanel


class SecondViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource,TCTableViewCellProtocol,UITextFieldDelegate {
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topVIew: UIStackView!
    
    @IBOutlet weak var numGuests: UITextField!
    @IBOutlet weak var tipPercent: UITextField!
    @IBOutlet weak var billAmount: UITextField!
    
    @IBOutlet weak var totalToPay: UITextField!
    @IBOutlet weak var totalTipToPay: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func touchBegan(_ sender: Any) {
        //IHKeyboardAvoiding.setAvoiding(tableView)
    }

    @IBAction func touchEnd(_ sender: Any) {
        //IHKeyboardAvoiding.setAvoiding(topVIew)
    }
    
    var numGuestpickerView:UIPickerView!
    var tipPercentpickerView:UIPickerView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        //Identify the active VC
        TCHelperClass.isFirstVC = false
        
    }
    
    override func viewDidLoad() {
        
        Mixpanel.sharedInstance()?.track("UnEqual Share Opened")
        super.viewDidLoad()
        
        //initially hide Results
        bottomView.alpha = 0
        
        //Text Field Delegates
        numGuests.delegate = self
        tipPercent.delegate = self
        
        //Set Master Data
        CellData.setGuestValues()
        CellData.setTipValues()
        
        //Picker View
        numGuestpickerView = UIPickerView()
        numGuestpickerView.delegate = self
        numGuestpickerView.backgroundColor = CellData.pickerBkgColor
        
        tipPercentpickerView = UIPickerView()
        tipPercentpickerView.delegate = self
        tipPercentpickerView.backgroundColor = CellData.pickerBkgColor
        
        numGuests.inputView = numGuestpickerView
        tipPercent.inputView = tipPercentpickerView
        
        tableView.dataSource = self
        
        TCHelperClass.addDoneButtonOnKeyboard(sendingVC: self, sendingTextFld: billAmount)
        
        //Tap gesture recognizer
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @IBAction func doCalculate(sender: AnyObject) {
        
        calculateResults()
        Mixpanel.sharedInstance()?.track("UnEqual Calculated")
    }
    
    func calculateResults() {
        
        //resign first responder
        dismissKeyboard()
        
        if let numGuests = CellData.guest_to_num_converter[numGuests.text!],
            let tipPercent = CellData.tip_to_num_converter[tipPercent.text!],
            let billAmount = Double(billAmount.text!){
            
            TCHelperClass.billAmount = billAmount
            TCHelperClass.numGuests = numGuests
            TCHelperClass.tipPercent = tipPercent
            
            totalTipToPay.text = String(format: "%.2f", TCHelperClass.getTotalTip())
            totalToPay.text =  String(format: "%.2f", billAmount + TCHelperClass.getTotalTip())
            
            tableView.reloadData()
            
            //show the results
            if self.bottomView.alpha == 0.0 {
                
                UIView.animate(withDuration: CellData.animationDuration, animations: {
                    self.bottomView.alpha = 1.0
                }) 
            }
            
        }else {
            
            numGuests.text = ""
            tipPercent.text = ""
            billAmount.text = ""
            
            //hide the bottom view
            if self.bottomView.alpha == 1.0 {
                
                UIView.animate(withDuration: CellData.animationDuration, animations: {
                    self.bottomView.alpha = 0.0
                }) 
                
            }
            
        }
        
        
        
    }
    
    
    
}

// MARK: TCTableViewCellProtocol protocol
extension SecondViewController{
    
    func calcAndReload() -> Void {
        
        TCHelperClass.resetCellValues()
        tableView.reloadData()
    }
    
    func keyboardWillShow(notification: Notification) {
        
        view.frame.origin.y -= getKeyboardHeight(notification: notification)
    }
    
    func keyboardWillHide(notification: Notification) {
        
        view.frame.origin.y += getKeyboardHeight(notification: notification)
    }
    
    func getKeyboardHeight(notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
}

// MARK: Logic for adding the Return button on the Decimal Keyboard
extension SecondViewController{
    
    
    func doneButtonAction()
    {
        self.billAmount.resignFirstResponder()
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
}

// MARK: Table View Data Source functions
extension SecondViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let helperArray = TCHelperClass.tcCellValues {
            
            return helperArray.count
        }
        
        return 0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellData.cellIdentifier) as! ListResultsTableViewCell
        
        cell.myCellDetails = TCHelperClass.tcCellValues![(indexPath as NSIndexPath).row]
        cell.personLabel.text = "Guest \((indexPath as NSIndexPath).row + 1)"
        
        cell.delegate = self
        
        return cell
        
    }
    
}

// MARK: Picker View functions
extension SecondViewController{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        //For example, if you wanted to do a picker for selecting time,
        //you might have 3 components; one for each of hour, minutes and seconds
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == numGuestpickerView{
            
            return CellData.guests.count
        }
        else {
            return CellData.tips.count
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == numGuestpickerView{
            
            return CellData.guests[row]
        }
        else {
            
            return CellData.tips[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        pickerView.reloadAllComponents()
        
        if pickerView == numGuestpickerView{
            
            numGuests.text = CellData.guests[row]
            
        } else {
            
            tipPercent.text =  CellData.tips[row]
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let color = (row == pickerView.selectedRow(inComponent: component)) ? UIColor.red : UIColor.purple
        
        if pickerView == numGuestpickerView{
            return NSAttributedString(string: CellData.guests[row], attributes: [NSForegroundColorAttributeName: color])
        } else {
            return NSAttributedString(string: CellData.tips[row], attributes: [NSForegroundColorAttributeName: color])
        }
    }
    
}

//MARK: UITextFieldDelegate implementation
extension SecondViewController {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField.text == "" {
            
            if textField == numGuests {
                
                numGuests.text = CellData.guests[numGuestpickerView.selectedRow(inComponent: 0)]
                
            }
            if textField == tipPercent {
                
                tipPercent .text = CellData.tips[tipPercentpickerView.selectedRow(inComponent: 0)]
            }
        }
        
        
    }
    
}
