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
    
    var pickOption: [String] = []
    var allXRArray :[Currency] = []
    var fromCurrency = ""
    var toCurrency = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        from.dataSource = self
        from.delegate = self
        to.delegate = self
        to.dataSource = self
        
        convertButton.layer.cornerRadius = 10
        
        
        let urlString = "http://apilayer.net/api/live?access_key=94217fdb9d33521f768f5803543f7c9b"
        //let parameter: Parameters = ["access_key": "94217fdb9d33521f768f5803543f7c9b", "currencies":""]
        
        Alamofire.request(urlString, method: .get, encoding: JSONEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    // Do what you need to with JSON here!
                    // The rest is all boiler plate code you'll use for API requests
                    let allXR = json["quotes"].dictionaryValue
                    //var allXRDict : [String:Double] = [:]
                    for (key,value) in allXR {
                        //allXRDict[key] = value.doubleValue
                        let curr = Currency(name: key,rate:value.doubleValue)
                        
                        self.allXRArray.append(curr)
                        self.pickOption.append(curr.name)
                        self.pickOption.sort()
                        
                        self.from.reloadAllComponents()
                        self.to.reloadAllComponents()
                        
                        self.from.reloadInputViews()
                        self.to.reloadInputViews()
                        
                    }
                }
            case .failure(let error):
                print(error)
            }
            
            
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        //For example, if you wanted to do a picker for selecting time,
        //you might have 3 components; one for each of hour, minutes and seconds
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return pickOption.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        //pickerView.reloadAllComponents()
        
//        if pickerView == numGuestpickerView{
//            
//            numGuests.text = CellData.guests[row]
//            
//        } else if pickerView == tipPercentpickerView {
//            
//            tipPercent.text =  CellData.tips[row]
//            
//        }
//            
//        else if pickerView.tag == 0{
//            
//            basePickerTextField.text = pickOption[row]
//            
//        } else if pickerView.tag == 1 {
//            
//            targetPickerTextField.text = pickOption[row]
//            
//        }
        
        if pickerView == from {
            fromText.text! = pickOption[row]
            fromCurrency = pickOption[row]
        }
        
        if pickerView == to {
            toText.text! = pickOption[row]
            toCurrency = pickOption[row]
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let color = (row == pickerView.selectedRow(inComponent: component)) ? UIColor.purple : UIColor.purple
        //let color2 = (row == pickerView.selectedRow(inComponent: component)) ? UIColor.white : UIColor.red
        
        return NSAttributedString(string: pickOption[row], attributes: [NSForegroundColorAttributeName: color])
    }
}

