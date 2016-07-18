//
//  SecondViewController.swift
//  Tip Calcly
//
//  Created by Abdalrahim Abdullah on 11/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SliderChangedDelegete{
    
    @IBOutlet var billAmountField: UITextField!
    @IBOutlet var tipSelector: UITextField!
    @IBOutlet var tipAmountField: UITextField!
    @IBOutlet var totalAmountField: UITextField!
    @IBOutlet var guests: UITextField!
    @IBOutlet var resultTable: UITableView!
   
    var pppA: Double = 0.0
    var tppA: Double = 0.0
    
    func changeSliders() {
        
        print(SliderChangedDelegete)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        resultTable.delegate = self
    
        resultTable.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let valueOne = guests.text {
           
            if let value = Int(valueOne) {
                return value
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ListResultsTableViewCell
        cell.delegate = self
        cell.billAmount.text = String(self.pppA)
        cell.tipAmount.text  = String(self.tppA)
        func changeSliders(cell: SliderChangedDelegete){
            cell.changeSliders()
        }
        
        return cell
    }
    
    
    @IBAction func calculateTip(sender: AnyObject) {
        dismissKeyboard()
        guard let billAmount = Double(billAmountField.text!) else {
            //show error
            billAmountField.text = ""
            tipAmountField.text = ""
            totalAmountField.text = ""
            self.guests.text = ""
            return
        }
        
        
        // all is well
        
        let roundedBillAmount = round(100*billAmount)/100
        let tipAmount = roundedBillAmount * Double(tipSelector.text!)!/100
        let roundedTipAmount = round(100*tipAmount)/100
        let totalAmount = roundedBillAmount + roundedTipAmount
        let guests = (totalAmount) / Double(self.guests.text!)!
        let tguests = (roundedTipAmount) / Double(self.guests.text!)!
        if (billAmountField.editing) {
            billAmountField.text = String(format: "%.2f", roundedBillAmount)
        }
        tipAmountField.text = String(format: "%.2f", roundedTipAmount)
        totalAmountField.text = String(format: "%.2f", totalAmount)
        
        self.pppA = guests
        self.tppA = tguests
        
        resultTable.reloadData()
        
    }
}