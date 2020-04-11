//
//  AppDelegate.swift
//  Yolanda
//
//  Created by Kelly Tran on 10/24/19.
//  Copyright © 2019 Kelly Tran. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    var locationManager: CLLocationManager?
    
    var notificationCenter: UNUserNotificationCenter?
    
  func application(_ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
    [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    
    // if the app was launched because of geofencing
    // create new instances and set self as their delegates
    if launchOptions?[UIApplication.LaunchOptionsKey.location] != nil {
        self.locationManager = CLLocationManager()
        self.locationManager!.delegate = self
     
        self.notificationCenter = UNUserNotificationCenter.current()
        self.notificationCenter!.delegate = self
        
    } else {
        // your app's "normal" behaviour goes here
        // ...

    // Override point for customization after application launch.
    
    //AIzaSyBPhUgsczlfTpmWDIb-_VARdGOTAAB0yjI
    GMSServices.provideAPIKey("AIzaSyBPhUgsczlfTpmWDIb-_VARdGOTAAB0yjI")
    GMSPlacesClient.provideAPIKey("AIzaSyBPhUgsczlfTpmWDIb-_VARdGOTAAB0yjI")
    
    self.locationManager = CLLocationManager()
    self.locationManager!.delegate = self
    
    self.locationManager = CLLocationManager()
          self.locationManager!.delegate = self
          
          // get the singleton object
          self.notificationCenter = UNUserNotificationCenter.current()
          
          // register as it's delegate
    notificationCenter!.delegate = self as? UNUserNotificationCenterDelegate

          // define what do you need permission to use
          let options: UNAuthorizationOptions = [.alert, .sound]
    
          // request permission
    notificationCenter!.requestAuthorization(options: options) { (granted, error) in
              if !granted {
                  print("Permission not granted")
              }
          }
    }
    
    self.window = UIWindow(frame: UIScreen.main.bounds)
    if let window = self.window {
        window.backgroundColor = UIColor.white
        
        let nav = UINavigationController()
        let mainView = ViewController()
        nav.viewControllers = [mainView]
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }
    
    FirebaseApp.configure()
    return true
  }
    
    // called when user Enters a monitored region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            // Do what you want if this information
            self.handleEvent(forRegion: region)
        }
    }
    
    func handleEvent(forRegion region: CLRegion!) {

        // customize your notification content
        let content = UNMutableNotificationContent()
        content.title = "Awesome title"
        content.body = "Well-crafted body message"
        content.sound = UNNotificationSound.default

        // when the notification will be triggered
        let timeInSeconds: TimeInterval = (60 * 15) // 60s * 15 = 15min
        // the actual trigger object
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInSeconds,
                                                        repeats: false)

        // notification unique identifier, for this example, same as the region to avoid duplicate notifications
        let identifier = region.identifier

        // the notification request object
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content,
                                            trigger: trigger)

        // trying to add the notification request to notification center
        notificationCenter!.add(request, withCompletionHandler: { (error) in
            if error != nil {
                print("Error adding notification with identifier: \(identifier)")
            }
        })
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // when app is onpen and in foregroud
        completionHandler(.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // get the notification identifier to respond accordingly
        let identifier = response.notification.request.identifier
        
        // do what you need to do
        print("hello")
        // ...
    }
}
