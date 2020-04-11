//
//  ViewController.swift
//  Yolanda
//
//  Created by Kelly Tran on 10/26/19.
//  Copyright © 2019 Kelly Tran. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ViewController: UIViewController {
    
    
    @IBOutlet weak var logo: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var cheatButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpElements()

    }
    
    func setUpElements() {
//        Utilities.styleFilledButton(loginButton)
//        Utilities.styleFilledButton(registerButton)
    }

    
}
