//
//  Utilities.swift
//  Yolanda
//
//  Created by Kelly Tran on 10/27/19.
//  Copyright © 2019 Kelly Tran. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    static func styleTextField(_ textfield:UITextField) {
        
        //create the bottom line
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x:0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        //remove border on textfield
        textfield.layer.addSublayer(bottomLine)
    }
    
    static func styleFilledButton(_ button:UIButton) {
        
        //Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
        button.frame = CGRect(x:0, y: button.frame.height - 2, width: button.frame.width, height: button.frame.height)
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        //Hollow rounded corner style
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemOrange.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
        button.frame = CGRect(x:0, y: button.frame.height - 2, width: button.frame.width, height: button.frame.height)
    }
    
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])[A-Za-z\\d$@$#!%*?&]{5,}")
        return passwordTest.evaluate(with: password)
    }
}


