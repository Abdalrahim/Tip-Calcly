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
    
    @IBOutlet var tipAmount: UITextField!
    
    @IBOutlet var billAmount: UITextField!
    
    
    @IBOutlet var slider: UISlider!
    
    @IBAction func valueChanged(sender: AnyObject) {
        
        delegate?.changeSliders()
        

    }
    var delegate : SliderChangedDelegete?
    

    @IBOutlet var lock: UISwitch!
    
}

protocol SliderChangedDelegete {
    func changeSliders()
    
}