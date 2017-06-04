//
//  ConvertingController.swift
//  Tip Calcly
//
//  Created by Abdalrahim Abdullah on 24/5/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage
import AlamofireNetworkActivityIndicator

class ConvertingController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    @IBOutlet weak var from: UIPickerView!
    
    @IBOutlet weak var to: UIPickerView!
    
    @IBOutlet weak var fromText: UILabel!
    
    @IBOutlet weak var toText: UILabel!
    
    @IBOutlet weak var convertButton: UIButton!
    
    @IBAction func back(_ sender: Any) {
        _ = navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: Any) {
        if fromCurrency == "" || toCurrency == "" {
            UIView.animate(withDuration: 0.2, animations: {
                self.convertButton.backgroundColor = UIColor.red
            })
            
            if fromCurrency == "" {
                UIView.animate(withDuration: 0.2, animations: {
                    self.fromText.text! = "Select a currency"
                    self.fromText.textColor = UIColor.red
                    
                    let when1 = DispatchTime.now() + 3
                    DispatchQueue.main.asyncAfter(deadline: when1) {
                        UIView.animate(withDuration: 0.5, animations: {
                            self.fromText.textColor = UIColor.purple
                            self.fromText.text! = "from?"
                            self.convertButton.backgroundColor = UIColor.purple
                        })
                    }
                })
                
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.toText.text! = "Select a currency"
                    self.toText.textColor = UIColor.red
                    
                    let when1 = DispatchTime.now() + 3
                    DispatchQueue.main.asyncAfter(deadline: when1) {
                        UIView.animate(withDuration: 0.5, animations: {
                            self.toText.text! = "to?"
                            self.toText.textColor = UIColor.purple
                            self.convertButton.backgroundColor = UIColor.purple
                        })
                    }
                })
            }
        } else {
            
            FirstViewController.someConv = fromCurrency
            FirstViewController.someConv2 = toCurrency
            _ = navigationController?.popToRootViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    static var pickOption: [String] = []
    static var allXRArray :[Currency] = []
    var fromCurrency = ""
    var toCurrency = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        from.dataSource = self
        from.delegate = self
        to.delegate = self
        to.dataSource = self
        
        convertButton.layer.cornerRadius = 10
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        //For example, if you wanted to do a picker for selecting time,
        //you might have 3 components; one for each of hour, minutes and seconds
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return ConvertingController.pickOption.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return ConvertingController.pickOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        if pickerView == from {
            fromText.text! = ConvertingController.pickOption[row]
            fromCurrency = ConvertingController.pickOption[row]
        }
        
        if pickerView == to {
            toText.text! = ConvertingController.pickOption[row]
            toCurrency = ConvertingController.pickOption[row]
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let color = (row == pickerView.selectedRow(inComponent: component)) ? UIColor.purple : UIColor.purple
        
        return NSAttributedString(string: ConvertingController.pickOption[row], attributes: [NSForegroundColorAttributeName: color])
    }
}

