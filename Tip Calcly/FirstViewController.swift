//
//  FirstViewController.swift
//  Tip Calcly
//
//  Created by Abdalrahim Abdullah on 11/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var billAmountField: UITextField!
    @IBOutlet weak var tipSelector: UITextField!
    @IBOutlet var tipAmountField: UITextField!
    @IBOutlet var totalAmountField: UITextField!
    @IBOutlet weak var guests: UITextField!
    @IBOutlet weak var ppp: UITextField!
    @IBOutlet weak var tpp: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func calculateTip(sender: AnyObject) {
        self.hideKeyboardWhenTappedAround()
        guard let billAmount = Double(billAmountField.text!) else {
            //show error
            billAmountField.text = ""
            tipAmountField.text = ""
            totalAmountField.text = ""
            self.guests.text = ""
            return
        }
        
        
        
        
        let roundedBillAmount = round(100*billAmount)/100
        let tipAmount = roundedBillAmount * Double(tipSelector.text!)!/100
        let roundedTipAmount = round(100*tipAmount)/100
        let totalAmount = roundedBillAmount + roundedTipAmount
        let guests = (totalAmount) / Double(self.guests.text!)!
        let tguests = (roundedTipAmount) / Double(self.guests.text!)!
        
        if (!billAmountField.editing) {
            billAmountField.text = String(format: "%.2f", roundedBillAmount)
        }
        tipAmountField.text = String(format: "%.2f", roundedTipAmount)
        totalAmountField.text = String(format: "%.2f", totalAmount)
        ppp.text = String(format: "%.2f", guests)
        tpp.text = String(format: "%.2f", tguests)
    }
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
