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

class FirstViewController:  UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITableViewDataSource {
    
    @IBOutlet var superView: UIView!
    
    @IBOutlet weak var equalView: UIView!
    
    @IBOutlet weak var numGuests: UITextField!
    @IBOutlet weak var tipPercent: UITextField!
    @IBOutlet weak var billAmount: UITextField!
    
    @IBOutlet weak var totalToPay: UILabel!
    @IBOutlet weak var totalTipToPay: UILabel!
    @IBOutlet weak var totalPerPerson: UILabel!
    @IBOutlet weak var tipPerPerson: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var table: UIView!
    
    @IBOutlet weak var calculateEqorUnEq: UISegmentedControl!
    
    //calculate when valuse change
    @IBAction func calculate(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {self.checkBarsAndCalculate()})
    }
    
    @IBAction func calculateBill(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {self.checkBarsAndCalculate()})
    }
    
    @IBAction func calculateTip(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {self.checkBarsAndCalculate()})
    }
    
    @IBAction func calculateGuests(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {self.checkBarsAndCalculate()})
    }
    
    @IBOutlet weak var cconvert: UIButton!
    
    @IBAction func cconvertAction(_ sender: Any) {
        performSegue(withIdentifier: "toConverter", sender: nil)
    }
    
    
    //conv will be used as a billamount sender
    var conv: String = ""
    
    var numGuestpickerView:UIPickerView!
    var tipPercentpickerView:UIPickerView!
    
    //setting the converters
    static var someConv = ""
    static var someConv2 = ""
    
    func checkBarsAndCalculate() {
        if numGuests.text! == "" || tipPercent.text! == "" || billAmount.text! == "" {
            if numGuests.text! == "" {
                numGuests.backgroundColor = UIColor.cyan
            }
            
            if tipPercent.text! == "" {
                tipPercent.backgroundColor = UIColor.cyan
            }
            
            if billAmount.text! == "" {
                billAmount.backgroundColor = UIColor.cyan
            }
            
        } else {
            if calculateEqorUnEq.selectedSegmentIndex == 0 {
                
                TCHelperClass.isFirstVC = true
                Mixpanel.sharedInstance()?.track("Equal Calculated")
                calculateResults()
                tableView.isUserInteractionEnabled = false
                table.isUserInteractionEnabled = false
                UIView.animate(withDuration: 0.2, animations: {
                    self.tableView.alpha = 0
                })
                equalView.isUserInteractionEnabled = true
                UIView.animate(withDuration: 0.2, animations: {
                    self.equalView.alpha = 1
                })
            }
            else if calculateEqorUnEq.selectedSegmentIndex == 1 {
                
                TCHelperClass.isFirstVC = false
                Mixpanel.sharedInstance()?.track("UnEqual Calculated")
                tableView.isUserInteractionEnabled = true
                table.isUserInteractionEnabled = true
                UIView.animate(withDuration: 0.2, animations: {
                    self.tableView.alpha = 1
                })
                equalView.isUserInteractionEnabled = false
                UIView.animate(withDuration: 0.2, animations: {
                    self.equalView.alpha = 0
                })
                calculateTable()
            }
        }
        
        let when1 = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when1) {
            UIView.animate(withDuration: 0.5, animations: {
                self.billAmount.backgroundColor = UIColor.white
                self.numGuests.backgroundColor = UIColor.white
                self.tipPercent.backgroundColor = UIColor.white
            })
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TCHelperClass.isFirstVC = true
        if FirstViewController.someConv != "" || FirstViewController.someConv2 != "" {
            self.cconvert.setTitle("\(FirstViewController.someConv) to \(FirstViewController.someConv2)", for: .normal)
            UIView.animate(withDuration: 0.2, animations: {self.checkBarsAndCalculate()})
        }
        
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        Mixpanel.sharedInstance()?.track("Equal Share Opened")
        tableView.isUserInteractionEnabled = false
        table.isUserInteractionEnabled = false
        tableView.alpha = 0
        equalView.isUserInteractionEnabled = false
        equalView.alpha = 0
        
        cconvert.layer.cornerRadius = 10
        
        internetConnection()
        
        calculateEqorUnEq.selectedSegmentIndex = 0
        
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
        
        tipPercentpickerView = UIPickerView()
        tipPercentpickerView.delegate = self
        tipPercentpickerView.backgroundColor = CellData.pickerBkgColor
        
        numGuests.inputView = numGuestpickerView
        tipPercent.inputView = tipPercentpickerView
        
        tableView.dataSource = self
        
        billAmount.delegate = self
        billAmount.keyboardType = UIKeyboardType.asciiCapableNumberPad
        billAmount.autocorrectionType = UITextAutocorrectionType.no
        
        // Done button on keyboard
        TCHelperClass.addDoneButtonOnKeyboard(sendingVC: self, sendingTextFld: billAmount)

        
        //Tap gesture recognizer to dismiss Keyboard and Picker View
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        API()
    }
    
    //Get converter values
    func API() {
        
        let urlString = "http://apilayer.net/api/live?access_key=94217fdb9d33521f768f5803543f7c9b"
        
        Alamofire.request(urlString, method: .get, encoding: JSONEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    // Do what you need to with JSON here!
                    // The rest is all boiler plate code you'll use for API requests
                    let allXR = json["quotes"].dictionaryValue
                    
                    for (key,value) in allXR {
                        
                        let curr = Currency(name: key,rate:value.doubleValue)
                        
                        ConvertingController.allXRArray.append(curr)
                        ConvertingController.pickOption.append(curr.name)
                        ConvertingController.pickOption.sort()
                    }
                }
            case .failure(let error):
                print(error)
            }
        } 
        
    }
    
    //Determine if the superview should or shouldn't move when change is tapped
    var keyboardAvoid = false {
        
        didSet {
            if keyboardAvoid == false {
                KeyboardAvoiding.avoidingView = totalToPay
                print("Total to Pay")
            } else {
                KeyboardAvoiding.avoidingView = superView
                print("Superb")
            }
        }
    }
    
    
    func calculateResults() {
        //resign first responder
        //dismissKeyboard()
        
        //sets conv as billamount to act as it
        conv = billAmount.text!
        
        if FirstViewController.someConv == "" || FirstViewController.someConv2 == ""{
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
                let baseCur = FirstViewController.someConv 
                let targetCur = FirstViewController.someConv2
                
                let baseRateToUSD = 1/(self.findExchange(name: baseCur))
                let USDTotargetRate = self.findExchange(name: targetCur)
                let baseToTargetRate = baseRateToUSD * USDTotargetRate
                
                let  btrUSD: Double = Double(billamountToConvert!)!
                let btt: Double = baseToTargetRate
                conv = String(format: "%.2f", (btt * btrUSD))
                
                Mixpanel.sharedInstance()?.track("Currency Converted")
            }
        }
        
        //calculate results only if key values are populated
        if let numGuests = CellData.guest_to_num_converter[numGuests.text!],
            let tipPercent = CellData.tip_to_num_converter[tipPercent.text!],
            let billAmount = Double(conv){
            
            
            TCHelperClass.billAmount = billAmount
            TCHelperClass.numGuests = numGuests
            TCHelperClass.tipPercent = tipPercent
            
            
            totalTipToPay.text = "\(String(format: "%.2f", TCHelperClass.getTotalTip()))$"
            
            totalToPay.text =  "\(String(format: "%.2f", billAmount + TCHelperClass.getTotalTip()))$"
            
            
            tipPerPerson.text = "\(String(format: "%.2f", TCHelperClass.getPerPersonTip()))$"
            
            totalPerPerson.text = "\(String(format: "%.2f", TCHelperClass.getPerPersonAmount() + TCHelperClass.getPerPersonTip()))$"
            
            
        }
        
        
    }
    
    func findExchange(name: String)->Double{
        for c in ConvertingController.allXRArray{
            if c.name == name{
                return c.rate
            }
        }
        return 0.0
    }
    
    //checks if the device is connected
    func internetConnection() {
        if Reachability.isConnectedToNetwork() == false {
            
            cconvert.isUserInteractionEnabled = false
            cconvert.backgroundColor = UIColor.gray
            cconvert.setTitle("Internet connection required", for: .normal)
        }
        else {
            
        }
        
    }
    
    @IBAction func touchBegan(_ sender: Any) {
        //KeyboardAvoiding.avoidingView = superView
        keyboardAvoid = true
    }
    
    @IBAction func touchEnd(_ sender: Any) {
        //KeyboardAvoiding.avoidingView = billAmount
        keyboardAvoid = false
        
    }
}

// MARK: Resign first responder Logic
extension FirstViewController {
    
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
extension FirstViewController {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        //For example, if you wanted to do a picker for selecting time,
        //you might have 3 components; one for each of hour, minutes and seconds
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == numGuestpickerView{
            
            return CellData.guests.count
            
        } else {
            
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
        
        let color = (row == pickerView.selectedRow(inComponent: component)) ? UIColor.white : UIColor.purple
        
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
                
                numGuests.text = CellData.guests[numGuestpickerView.selectedRow(inComponent: 0)]
                
            }
            if textField == tipPercent {
                
                tipPercent .text = CellData.tips[tipPercentpickerView.selectedRow(inComponent: 0)]
            }
        }
        
        
    }
    
}
extension FirstViewController {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let helperArray = TCHelperClass.tcCellValues {
            
            return helperArray.count
        }
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellData.cellIdentifier) as! ListResultsTableViewCell
        
        cell.totalAmount.delegate = self
        cell.totalAmount.keyboardType = UIKeyboardType.asciiCapableNumberPad
        cell.totalAmount.autocorrectionType = UITextAutocorrectionType.no
        
        cell.myCellDetails = TCHelperClass.tcCellValues![(indexPath as NSIndexPath).row]
        cell.personLabel.text = "Guest \((indexPath as NSIndexPath).row + 1)"
        
        cell.delegate = self
        
        return cell
        
    }
    
    func calculateTable() {
        
        //resign first responder
        //dismissKeyboard()
        
        conv = billAmount.text!
        
        if FirstViewController.someConv == "" || FirstViewController.someConv2 == ""{
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
                let baseCur = FirstViewController.someConv
                let targetCur = FirstViewController.someConv2
                
                let baseRateToUSD = 1/(self.findExchange(name: baseCur))
                let USDTotargetRate = self.findExchange(name: targetCur)
                let baseToTargetRate = baseRateToUSD * USDTotargetRate
                
                let  btrUSD: Double = Double(billamountToConvert!)!
                let btt: Double = baseToTargetRate
                conv = String(format: "%.2f", (btt * btrUSD))
                
                Mixpanel.sharedInstance()?.track("Currency Converted")
            }
        }
        
        if let numGuests = CellData.guest_to_num_converter[numGuests.text!],
            let tipPercent = CellData.tip_to_num_converter[tipPercent.text!],
            let billAmount = Double(conv){
            
            
            TCHelperClass.billAmount = billAmount
            TCHelperClass.numGuests = numGuests
            TCHelperClass.tipPercent = tipPercent
            
            totalTipToPay.text = "\(String(format: "%.2f", TCHelperClass.getTotalTip()))$"
            totalToPay.text =  "\(String(format: "%.2f", billAmount + TCHelperClass.getTotalTip()))$"
            
            tableView.reloadData()
            
        }
    }
}

extension FirstViewController: TCTableViewCellProtocol {
    func calcAndReload() -> Void {
        
        TCHelperClass.resetCellValues()
        tableView.reloadData()
    }
    
    func keyboardWillShow(notification: Notification) {
        
        view.frame.origin.y -= getKeyboardHeight(notification: notification)
        print("olleh")
    }
    
    func keyboardWillHide(notification: Notification) {
        
        view.frame.origin.y += getKeyboardHeight(notification: notification)
        print("hello")
    }
    
    func getKeyboardHeight(notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
}
