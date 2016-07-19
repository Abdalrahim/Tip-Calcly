//
//  SecondViewController.swift
//  Tip Calcly
//
//  Created by Abdalrahim Abdullah on 11/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource,TCTableViewCellProtocol {
    
    
    @IBOutlet weak var numGuests: UITextField!
    @IBOutlet weak var tipPercent: UITextField!
    @IBOutlet weak var billAmount: UITextField!
    
    @IBOutlet weak var totalToPay: UITextField!
    @IBOutlet weak var totalTipToPay: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    /* var tcCellValues:[TCCellValues]? {
     didSet{
     
     print ("roger wilco")
     if let _ = tcCellValues {
     
     tableView.reloadData()
     
     }
     
     }
     
     }
     */
    
    var numGuestpickerView:UIPickerView!
    var tipPercentpickerView:UIPickerView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Picker View
        numGuestpickerView = UIPickerView()
        numGuestpickerView.delegate = self
        
        tipPercentpickerView = UIPickerView()
        tipPercentpickerView.delegate = self
        
        numGuests.inputView = numGuestpickerView
        tipPercent.inputView = tipPercentpickerView
        
        tableView.dataSource = self
        
        self.addDoneButtonOnKeyboard()
        
    }
    
    func calculateResults() {
        
        if let numGuests = Int(numGuests.text!), tipPercent = Double(tipPercent.text!), billAmount = Double(billAmount.text!){
            
            totalTipToPay.text = String(round( billAmount * tipPercent / 100 * 100 ) / 100)
            totalToPay.text =  String (round ((billAmount + Double(totalTipToPay.text!)!) * 100 ) / 100 )
            
            TCHelperClass.billAmount = billAmount
            TCHelperClass.numGuests = numGuests
            TCHelperClass.tipPercent = tipPercent
            
            //tcCellValues = TCHelperClass.tcCellValues
            
            tableView.reloadData()
            
        }
        
    }
    
    
    
}

// MARK: TCTableViewCellProtocol protocol
extension SecondViewController{
    
    func calcAndReload() -> Void {
        
        TCHelperClass.seCellValues()
        tableView.reloadData()
    }
    
}

// MARK: Logic for adding the Return button on the Decimal Keyboard
extension SecondViewController{
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Calculate Now", style: UIBarButtonItemStyle.Done, target: self, action: #selector(doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.billAmount.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction()
    {
        self.billAmount.resignFirstResponder()
        calculateResults()
    }
    
    
}

// MARK: Table View Data Source functions
extension SecondViewController{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let helperArray = TCHelperClass.tcCellValues {
            
            return helperArray.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! ListResultsTableViewCell
        
        cell.myCellDetails = TCHelperClass.tcCellValues![indexPath.row]
        
        cell.delegate = self
        
        return cell
        
    }
    
}

// MARK: Picker View functions
extension SecondViewController{
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == numGuestpickerView{
            
            return TCHelperClass.numGuestOptions.count
        }
        else {
            return TCHelperClass.tipPercentOptions.count
        }
        
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == numGuestpickerView{
            
            return TCHelperClass.numGuestOptions[row]
        }
        else {
            
            return TCHelperClass.tipPercentOptions[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == numGuestpickerView{
            
            numGuests.text = TCHelperClass.numGuestOptions[row]
            calculateResults()
            
        } else {
            
            tipPercent.text =  TCHelperClass.tipPercentOptions[row]
            calculateResults()
        }
        
        
    }
    
}

