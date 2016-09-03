//
//  CellData.swift
//  Tip Calcly
//
//  Created by Abdalrahim Abdullah on 24/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit

struct CellData {
    
    static let pickerBkgColor = UIColor(red: 135/255.0, green: 206/255.0, blue: 250/255.0, alpha: 1.0)
    
    static let cellIdentifier = "cell"
    
    static let animationDuration = 0.5
    
    static let single_guest = "Guest"
    static let many_guests  = "Guests"
    
    static let tipSymbol  = "%"
    
    static let GuestCount = 50
    static let TipValueCount = 50
    
    static var  guests:[String]!
    static var guest_to_num_converter:[String:Int]!
    
    static var tips:[String]!
    static var tip_to_num_converter:[String:Double]!
    
    
    static func setGuestValues() {
        
        
        if let _ = guests {
            
            return
        }
        
        // Not initialized, then populate
        guests = [String]()
        guest_to_num_converter = [String:Int]()
        
        for counter in 1...GuestCount {
            
            if counter == 1 {
                guests.append( "\(counter) \(single_guest)")
                
            }
            else {
                guests?.append( "\(counter) \(many_guests)")
            }
            
            guest_to_num_converter[guests[counter - 1 ]] = counter
        }
        
        
    }
    
    
    static func setTipValues() {
        
        if let _ = tips{
            return
        }
        
        // Not initialized, then populate
        tips = [String]()
        tip_to_num_converter = [String:Double]()
        
        for counter in 0...TipValueCount {
            tips.append( "\(counter ) \(tipSymbol) ")
            tip_to_num_converter[tips[counter - 0]] = Double(counter)
        }
        
        
    }
    
    
}