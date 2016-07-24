//
//  CellData.swift
//  Tip Calcly
//
//  Created by Abdalrahim Abdullah on 24/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation

struct CellData {
    
    static let single_guest = "Guest"
    static let many_guests = "Guests"
    
    static let tipSymbol  = "%"
    
    static let GuestCount = 50
    static let TipValueCount = 50
    
    static var  guests:[String]!
    static var guest_to_num_converter:[String:Int]!
    
    //taking a risk with optionals
    static var tips:[String]!
    static var tip_to_num_converter:[String:Double]!
    
    
    static func setGuestValues() {
        
        guests = [String]()
        guest_to_num_converter = [String:Int]()
        
        for counter in 1...GuestCount {
            
            if counter == 1 {
                guests.append( "\(counter) \(single_guest) ")
                
            }
            else {
                guests?.append( "\(counter) \(many_guests) ")
            }
            
            guest_to_num_converter[guests[counter - 1 ]] = counter
        }
        
        
    }
    
    
    static func setTipValues() {
        
        tips = [String]()
        tip_to_num_converter = [String:Double]()
        
        for counter in 1...TipValueCount {
            
            tips.append( "\(counter ) \(tipSymbol) ")
            tip_to_num_converter[tips[counter - 1]] = Double(counter)
            
        }
        
        
    }
    
    
}
