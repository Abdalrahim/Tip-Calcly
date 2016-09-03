//
//  FirstViewController.swift
//  Tip Calcly
//
//  Created by Abdalrahim Abdullah on 11/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Mixpanel
import UIKit
import IHKeyboardAvoiding
import SwiftyJSON
import Alamofire
import AlamofireImage
import AlamofireNetworkActivityIndicator

class FirstViewController:  UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var bottomView: UIView!
    
    var allXRArray :[Currency] = []
    
    @IBOutlet weak var numGuests: UITextField!
    @IBOutlet weak var tipPercent: UITextField!
    @IBOutlet weak var billAmount: UITextField!
    
    @IBOutlet weak var totalToPay: UITextField!
    @IBOutlet weak var totalTipToPay: UITextField!
    @IBOutlet weak var totalPerPerson: UITextField!
    @IBOutlet weak var tipPerPerson: UITextField!
    
    @IBOutlet weak var basePickerTextField: UITextField!
    @IBOutlet weak var targetPickerTextField: UITextField!
    
    @IBOutlet weak var currencyConvView: UIStackView!
    @IBOutlet weak var convertedView: UIStackView!
    @IBOutlet weak var connectionView: UIStackView!
    
    //conv is an empty string that could be used like the billamount to get converted to diff currency
    var conv: String = ""
    
    var numGuestpickerView:UIPickerView!
    var tipPercentpickerView:UIPickerView!
    
    var basePickerView = UIPickerView()
    var targetPickerView = UIPickerView()
    
    var pickOption: [String] = []
    
    @IBAction func doCalculate(sender: AnyObject) {
        Mixpanel.sharedInstance().track("Equal Calculated")
        calculateResults()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        TCHelperClass.isFirstVC = true
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        Mixpanel.sharedInstance().track("Equal Share Opened")
        //initially hide Results
        bottomView.alpha = 0
        convertedView.alpha = 0
        connectionView.alpha = 0
        
        internetConnection()
        //Set Master Data
        CellData.setGuestValues()
        CellData.setTipValues()
        
        //Text Field Delegates
        numGuests.delegate = self
        tipPercent.delegate = self
        
        //Picker View
        numGuestpickerView = UIPickerView()
        numGuestpickerView.delegate = self
        numGuestpickerView.backgroundColor = CellData.pickerBkgColor
        
        self.basePickerView.delegate = self
        self.targetPickerView.delegate = self
        
        basePickerTextField.inputView = self.basePickerView
        targetPickerTextField.inputView = self.targetPickerView
        
        self.basePickerView.tag = 0
        self.targetPickerView.tag = 1
        
        tipPercentpickerView = UIPickerView()
        tipPercentpickerView.delegate = self
        tipPercentpickerView.backgroundColor = CellData.pickerBkgColor
        
        numGuests.inputView = numGuestpickerView
        tipPercent.inputView = tipPercentpickerView
        
        // Done button on keyboard
        TCHelperClass.addDoneButtonOnKeyboard(self, sendingTextFld: billAmount)
        TCHelperClass.addDoneButtonOnKeyboard(self, sendingTextFld: basePickerTextField)

        
        //Tap gesture recognizer to dismiss Keyboard and Picker View
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //API
        
        let apiToContact = "http://apilayer.net/api/live"
        let parameter = ["access_key": "94217fdb9d33521f768f5803543f7c9b", "currencies":""]
        
        Alamofire.request(.GET, apiToContact, parameters: parameter).validate().responseJSON() { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    // Do what you need to with JSON here!
                    // The rest is all boiler plate code you'll use for API requests
                    let allXR = json["quotes"].dictionaryValue
                    //                    var allXRDict : [String:Double] = [:]
                    for (key,value) in allXR {
                        //                        allXRDict[key] = value.doubleValue
                        let curr = Currency(name: key,rate:value.doubleValue)
                        self.allXRArray.append(curr)
                        self.pickOption.append(curr.name)
                        //print(" THIS IS THE \(allXR.count)")
                    }
                    
                }
            case .Failure(let error):
                print(error)
            }
        }
        
    }
    
    
    func calculateResults() {
        //resign first responder
        dismissKeyboard()
        conv = billAmount.text!
        if basePickerTextField.text == "" || targetPickerTextField.text == ""{
            //doesn't do anything and skips to convert the currency
        } else {
        guard let billamountToConvert = Optional(self.billAmount.text) else {
            //show error
            self.billAmount.text = ""
            return
        }
            if self.billAmount.text == "" {
                //doesn't proceed if bill amount was empty
            }
            else {
                let baseCur = basePickerTextField.text ?? ""
                let targetCur = targetPickerTextField.text ?? ""
                
                let baseRateToUSD = 1/(self.findExchange(baseCur))
                let USDTotargetRate = self.findExchange(targetCur)
                let baseToTargetRate = baseRateToUSD * USDTotargetRate
                
                let  btrUSD: Double = Double(billamountToConvert!)!
                let btt: Double = baseToTargetRate
                conv = String(format: "%.2f", (btt * btrUSD))
                
                //billAmount.text = conv
                
                if self.convertedView.alpha == 0.0 {
                    UIView.animateWithDuration(3) {
                        self.convertedView.alpha = 1.0
                    }
                }
                if self.convertedView.alpha == 1.0 {
                    UIView.animateWithDuration(2) {
                        self.convertedView.alpha = 0.0
                    }
                }
                
                Mixpanel.sharedInstance().track("Currency Converted")
            }
        }
        //calculate results only if key values are populated
        if let numGuests = CellData.guest_to_num_converter[numGuests.text!],
            tipPercent = CellData.tip_to_num_converter[tipPercent.text!],
            billAmount = Double(conv){
            
            
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
    func findExchange(name: String)->Double{
        for c in self.allXRArray{
            if c.name == name{
                return c.rate
            }
        }
        return 0.0
    }
    //checks if the device is connected
    func internetConnection() {
        if Reachability.isConnectedToNetwork() == false {
            currencyConvView.alpha = 0.0
            if connectionView.alpha == 0.0 {
                connectionView.alpha = 1.0
            }
        }
        else {
            currencyConvView.alpha = 1.0
            connectionView.alpha = 0.0
        }
        
    }
    
    
}

// MARK: Resign first responder Logic
extension FirstViewController{
    
    func doneButtonAction()
    {
        billAmount.resignFirstResponder()
        dismissKeyboard()
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
            
        } else if pickerView == basePickerView {
            
            return pickOption.count
            
        } else if pickerView == targetPickerView {
            
            return pickOption.count
        }
        else {
            
            return CellData.tips.count
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == numGuestpickerView{
            
            return CellData.guests[row]
            
        }
        else if pickerView == tipPercentpickerView{
            
            return CellData.tips[row]
        }
        
        else if pickerView == basePickerView {
            
            return pickOption[row]
            
        } else {
            
            return pickOption[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        pickerView.reloadAllComponents()
        
        if pickerView == numGuestpickerView{
            
            numGuests.text = CellData.guests[row]
            
        } else if pickerView == tipPercentpickerView {
            
            tipPercent.text =  CellData.tips[row]
            
        }
        
        else if pickerView.tag == 0{
            
            basePickerTextField.text = pickOption[row]
            
        } else if pickerView.tag == 1 {
            
            targetPickerTextField.text = pickOption[row]
            
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let color = (row == pickerView.selectedRowInComponent(component)) ? UIColor.whiteColor() : UIColor.purpleColor()
        let color2 = (row == pickerView.selectedRowInComponent(component)) ? UIColor.whiteColor() : UIColor.redColor()
        
        if pickerView == numGuestpickerView{
            return NSAttributedString(string: CellData.guests[row], attributes: [NSForegroundColorAttributeName: color])
            
        } else if pickerView == basePickerView {
            return NSAttributedString(string: pickOption[row], attributes: [NSForegroundColorAttributeName: color2])
            
        } else if pickerView == targetPickerView {
            return NSAttributedString(string: pickOption[row], attributes: [NSForegroundColorAttributeName: color2])
            
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