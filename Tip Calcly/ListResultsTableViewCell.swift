//
//  ListResultsTableView.swift
//  Tip Calcly
//
//  Created by Abdalrahim Abdullah on 12/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import UIKit

class ListResultsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tipAmount: UITextField!
    
    @IBOutlet weak var billAmount: UITextField!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBAction func valueChanged(sender: AnyObject) {
//        slider!.minimumValue = 0
//        slider!.maximumValue = 
        print (slider.value)
    }
    
    @IBOutlet weak var lock: UISwitch!
    
}