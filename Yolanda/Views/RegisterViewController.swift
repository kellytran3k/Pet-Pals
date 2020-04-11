//
//  RegisterViewController.swift
//  Yolanda
//
//  Created by Kelly Tran on 10/26/19.
//  Copyright © 2019 Kelly Tran. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var signUpLabel: UILabel!

    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var createPasswordTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var petPalNameTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
        
        //hides error label
        errorLabel.alpha = 0
        
      //Utilities.styleTextField(emailTextField)
      //Utilities.styleTextField(createPasswordTextField)
        Utilities.styleFilledButton(registerButton)
        
    }
    
    //Check the fields and validate that the data is correct. If everything is correct, it returns nil. Otherwise, it returns the error message.
    
    func validateFields() -> String? {
        
        //check that all fields are filled in
            if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            ||
            createPasswordTextField.text?.trimmingCharacters(in: . whitespacesAndNewlines) == ""
                
            ||
            petPalNameTextField.text?.trimmingCharacters(in: . whitespacesAndNewlines) == ""
            {
            
            return "Please fill in all fields"
        }
        
        //check if the password is secure
        let cleanedPassword = createPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            //password isn't secure enough
            return "Password has to have at least 5 characters and a number."
        }
         
        return nil
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        
        //validate the fields
        let error = validateFields()
        
        if error != nil {
            //There was an error
            showError(error!)
        }
        else {
            
            //creates cleaned versions of the data
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let createPassword = createPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let createPetPal = petPalNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let createHealthPoints = 0
            
            let createLovePoints = 0
            
            let createLuckPoints = 0
            
            let createRecyclables = 0
            
            let createCameraPermission = true
            
            // creates the user
            Auth.auth().createUser(withEmail: email, password: createPassword) {
                (result, err) in
                
                // Check for errors
                if err != nil {
                    // There was an error creating the user
                    self.showError("Error creating user")
                }
                
                else {
                    
                    //User was created successfully, stores information
                    let db = Database.database()
                    
                    guard let uid = result?.user.uid else { return }
                    
                    //database -
                    let values = ["email": email, "password": createPassword, "pet": createPetPal,"health-points": createHealthPoints, "love-points": createLovePoints,"luck-points": createLuckPoints, "recyclables": createRecyclables, "camera-permission": createCameraPermission, "uid": result!.user.uid] as [String : Any]
                    db.reference().child("users").child(uid).updateChildValues(values) { (error, ref) in
                        if let error = error {
                            print("Failed to sign user up with error: ", error.localizedDescription)
                        }
                        print("Successfully signed user up..")
                    }
                    
                    //Transition to homescreen
                    self.transitionToHome()
                }
            }

        }
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {
        
       //function to transition to homescreen
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}
