//
//  HomeViewController.swift
//  Yolanda
//
//  Created by Kelly Tran on 10/26/19.
//  Copyright © 2019 Kelly Tran. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth

class HomeViewController: UIViewController {

    @IBOutlet weak var PetPalNameLabel: UILabel!
    
    @IBOutlet weak var tempPet: UIImageView!
    
    @IBOutlet weak var InfoButton: UIButton!
    
    @IBOutlet weak var MapsButton: UIButton!
    
    @IBOutlet weak var CameraButton: UIButton!
    
    @IBOutlet weak var messagesLabel: UILabel!
    
    // progress views
    
    @IBOutlet weak var HealthProgressView: UIProgressView!
    
    @IBOutlet weak var LoveProgressView: UIProgressView!
    
    @IBOutlet weak var KarmaProgressView: UIProgressView!
    
    @IBOutlet weak var RecyclablesLabel: UILabel!
    
    // references Firebase
    var ref: DatabaseReference?
    
    var databaseHandle:DatabaseHandle?
    
    var timer = Timer()
    
// --------------------------------------------------
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        authenticateUserAndConfigureView()
        setUpElements()
        loadUserData()
        messagesLabel.alpha = 0
        referenceData()

        
        
// ----------------------------------------------------------------------
        
        
        // timer for progress view bar
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(HomeViewController.decreaseProgress), userInfo: nil, repeats: true)
        
    }
    
//-----------------------------------------------------------------------
    
    func setUpElements() {
//        Utilities.styleFilledButton(InfoButton)
//        Utilities.styleFilledButton(MapsButton)
//        Utilities.styleFilledButton(CameraButton)
        
    }
    
    @objc func decreaseProgress() {
        HealthProgressView.progress -= 0.1
        LoveProgressView.progress -= 0.05
        KarmaProgressView.progress -= 0.01
        
        if (HealthProgressView.progress < 0.1 ||
            LoveProgressView.progress < 0.1 ||
            KarmaProgressView.progress < 0.1) {
            
            sadMessages()
        }
    }
    
    @objc func increaseHealthProgress() {
        HealthProgressView.progress += 0.20
        
        if (HealthProgressView.progress >= 0.7) {
            happyMessages()
        }
    }
    
    @objc func increaseLoveProgress() {
        LoveProgressView.progress += 0.20
        if (HealthProgressView.progress >= 0.7) {
            happyMessages()
        }
    }
    
    @objc func increaseKarmaProgress() {
        KarmaProgressView.progress += 0.20
        if (HealthProgressView.progress >= 0.7) {
            happyMessages()
        }
    }
    
    func happyMessages() {
        let randomInt = Int.random(in: 1..<10)
        switch randomInt {
        case 1:
            messagesLabel.text = "I love you!"
        case 2:
            messagesLabel.text = "I'm so glad to have you 💖"
        case 3:
            messagesLabel.text = "Thank you for everything 🥺"
        case 4:
            messagesLabel.text = "Let's be bestfriends forever!"
        case 5:
            messagesLabel.text = "You take care of me so well!"
        case 6:
            messagesLabel.text = "I feel so loved 🥺"
        case 7:
             messagesLabel.text = "I love you 3000"
        case 8:
            messagesLabel.text = "Yay yay yay!"
        case 9:
            messagesLabel.text = "☆*･゜ﾟ･*\\(^O^)/*･゜ﾟ･*☆"
        default:
            messagesLabel.text = "I will never forget you!!!"
        }
        
        messagesLabel.alpha = 1
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.messagesLabel.alpha = 0
        }
    }
    
    func sadMessages() {
        let randomInt = Int.random(in: 1..<11)
        switch randomInt {
        case 1:
            messagesLabel.text = "Hi... are you still there?"
        case 2:
            messagesLabel.text = "Please come back..."
        case 3:
            messagesLabel.text = "Where are you, owner?"
        case 4:
            messagesLabel.text = "Ahh.. I'm a little hungry"
        case 5:
            messagesLabel.text = "Don't leave me.."
        case 6:
            messagesLabel.text = "Is anybody there?"
        case 7:
            messagesLabel.text = "*sigh* (っ- ‸ – ς)"
        case 8:
            messagesLabel.text = "When will you be back..?"
        case 9:
            messagesLabel.text = "Hello..?"
        case 10:
            messagesLabel.text = "I'm bored (⌯˃̶᷄ ﹏ ˂̶᷄⌯)"
        default:
            messagesLabel.text = "I miss you..."
        }
        messagesLabel.alpha = 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.messagesLabel.alpha = 0
        }
    }
    

    func loadUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("users").child(uid).child("pet").observeSingleEvent(of: .value) { (DataSnapshot) in
            
            guard let petData = DataSnapshot.value as? String else { return }
            self.PetPalNameLabel.text = "\(petData)"
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            let navController = UINavigationController(rootViewController: ViewController())
            navController.navigationBar.barStyle = .black
            self.present(navController, animated: true, completion: nil)
        } catch let error {
            print("Failed to sign out with error..", error)
        }
    }
    
    @objc func handleSignOut() {
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
            self.signOut()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func authenticateUserAndConfigureView() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let navController = UINavigationController(rootViewController: ViewController())
                navController.navigationBar.barStyle = .black
                self.present(navController, animated: true, completion: nil)
            }
        } else {
            configureViewComponents()
            loadUserData()
        }
    }
    
    func configureViewComponents() {
        
        navigationItem.title = "Firebase Login"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_arrow_back_white_24dp"), style: .plain, target: self, action: #selector(handleSignOut))
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationController?.navigationBar.barTintColor = UIColor.green

    }
    
    func referenceData() {
              let db = Database.database()
        
              guard let uid = Auth.auth().currentUser?.uid else { return }
          
              
              db.reference().child("users").child(uid).child("recyclables").observe(.value) { (DataSnapshot) in

                  guard let initialRecyclables = DataSnapshot.value as? Int64 else
                  { return }
                  
                  self.RecyclablesLabel.text = "Recyclables: \(initialRecyclables)"
                  
              }
              
              db.reference().child("users").child(uid).child("health-points").observe(.value) { (DataSnapshot) in
                  
                  self.increaseHealthProgress()
                  print("Health Progress increased")
              }
              
              db.reference().child("users").child(uid).child("love-points").observe(.value) { (DataSnapshot) in
                  
                  self.increaseLoveProgress()
                  print("Love Progress increased")
              }
              
              db.reference().child("users").child(uid).child("luck-points").observe(.value) { (DataSnapshot) in
                  
                  self.increaseKarmaProgress()
                  print("Karma Progress increased")
              }
        
    }

}

