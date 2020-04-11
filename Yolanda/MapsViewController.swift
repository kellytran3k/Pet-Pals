//
//  MapsViewController.swift
//  Yolanda
//
//  Created by Kelly Tran on 11/7/19.
//  Copyright © 2019 Kelly Tran. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

//geocoder
let geocoder = CLGeocoder()
var placemark: CLPlacemark?
var isPerformingReverseGeocoding = false
var lastGeocodingError: Error?

struct MyPlace {
    var name: String
    var lat: Double
    var long: Double
}

class MapsViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate, UITextFieldDelegate {

    let currentLocationMarker = GMSMarker()
    var locationManager = CLLocationManager()
    var chosenPlace: MyPlace?

    let customMarkerWidth: Int = 50
    let customMarkerHeight: Int = 70

    let previewDemoData = [(title: "Food", img: #imageLiteral(resourceName: "fire_fox"), price: 10), (title: "Food", img: #imageLiteral(resourceName: "dark_lion"), price: 8), (title: "Treasure", img: #imageLiteral(resourceName: "dark_lion"), price: 12)]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        self.view.backgroundColor = UIColor.white
        myMapView.delegate=self

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.distanceFilter = 100

        setupViews()

        initGoogleMaps()

        txtFieldSearch.delegate=self
    }

    //MARK: textfield
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self

        let filter = GMSAutocompleteFilter()
        autoCompleteController.autocompleteFilter = filter

        self.locationManager.startUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)
        return false
    }

    // MARK: GOOGLE AUTO COMPLETE DELEGATE
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let lat = place.coordinate.latitude
        let long = place.coordinate.longitude

        showPartyMarkers(lat: lat, long: long)

        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
        myMapView.camera = camera
        txtFieldSearch.text=place.formattedAddress
        chosenPlace = MyPlace(name: place.formattedAddress!, lat: lat, long: long)
        let marker=GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.title = "\(place.name)"
        marker.snippet = "\(place.formattedAddress!)"
        marker.map = myMapView

        self.dismiss(animated: true, completion: nil) // dismiss after place selected
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("ERROR AUTO COMPLETE \(error)")
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }

    func initGoogleMaps() {
        let camera = GMSCameraPosition.camera(withLatitude: 28.7041, longitude: 77.1025, zoom: 17.0)
        self.myMapView.camera = camera
        self.myMapView.delegate = self
        self.myMapView.isMyLocationEnabled = true
    }

    // MARK: CLLocation Manager Delegate

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while getting location \(error)")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
        let location = locations.last
        let lat = (location?.coordinate.latitude)!
        let long = (location?.coordinate.longitude)!
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)

        self.myMapView.animate(to: camera)

        showPartyMarkers(lat: lat, long: long)
    }

    // MARK: GOOGLE MAP DELEGATE
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return false }
        let img = customMarkerView.img!
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: img, borderColor: UIColor.white, tag: customMarkerView.tag)

        marker.iconView = customMarker

        return false
    }

    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return nil }
        let data = previewDemoData[customMarkerView.tag]
        binsPreviewView.setData(title: data.title, img: data.img, price: data.price)
        return binsPreviewView
    }

    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        let tag = customMarkerView.tag
        binsTapped(tag: tag)
    }

    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        let img = customMarkerView.img!
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: img, borderColor: UIColor.darkGray, tag: customMarkerView.tag)
        marker.iconView = customMarker
    }

    func showPartyMarkers(lat: Double, long: Double) {
        myMapView.clear()
            
            let librarymarker=GMSMarker()
            let langdalemarker=GMSMarker()
            let aderholdmarker=GMSMarker()
            
            let customMarker0 = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: previewDemoData[0].img, borderColor: UIColor.darkGray, tag: 0)
        
                librarymarker.iconView=customMarker0
            
            //library
            let geofenceLibraryCenter = CLLocationCoordinate2DMake(33.752740, -84.386566)
            librarymarker.position = geofenceLibraryCenter
            let geofenceLibraryRegion = CLCircularRegion(center: geofenceLibraryCenter, radius: 1000, identifier: "LibraryBin")
            locationManager.startMonitoring(for: geofenceLibraryRegion)
            geofenceLibraryRegion.notifyOnEntry = true
            geofenceLibraryRegion.notifyOnExit = true
            //
            
            let customMarker1 = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: previewDemoData[1].img, borderColor: UIColor.darkGray, tag: 1)
        
                langdalemarker.iconView=customMarker1
            
            //langdale
            let geofenceLangdaleCenter = CLLocationCoordinate2DMake(33.753236, -84.387122)
            langdalemarker.position = geofenceLangdaleCenter
            let geofenceLangdaleRegion = CLCircularRegion(center: geofenceLangdaleCenter, radius: 1000, identifier: "LangdaleBin")
            locationManager.startMonitoring(for: geofenceLangdaleRegion)
            geofenceLangdaleRegion.notifyOnEntry = true
            geofenceLangdaleRegion.notifyOnExit = true
        
            let customMarker2 = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: previewDemoData[2].img, borderColor: UIColor.darkGray, tag: 2)
        
                aderholdmarker.iconView=customMarker2
            
            //aderhold
            let geofenceAderholdCenter = CLLocationCoordinate2DMake(33.756294, -84.389194)
            aderholdmarker.position = geofenceAderholdCenter
            let geofenceAderholdRegion = CLCircularRegion(center: geofenceAderholdCenter, radius: 1000, identifier: "AderholdBin")
            locationManager.startMonitoring(for: geofenceAderholdRegion)
            geofenceAderholdRegion.notifyOnEntry = true
            geofenceAderholdRegion.notifyOnExit = true
        
            librarymarker.map = self.myMapView
            langdalemarker.map = self.myMapView
            aderholdmarker.map = self.myMapView
    }

    @objc func btnMyLocationAction() {
        let location: CLLocation? = myMapView.myLocation
        if location != nil {
            myMapView.animate(toLocation: (location?.coordinate)!)
        }
    }

    @objc func binsTapped(tag: Int) {
        let v=DetailsViewController()
        v.passedData = previewDemoData[tag]
        self.navigationController?.pushViewController(v, animated: true)
    }

    func setupTextField(textField: UITextField, img: UIImage){
        textField.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
        imageView.image = img
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        paddingView.addSubview(imageView)
        textField.leftView = paddingView
    }

    func setupViews() {
        view.addSubview(myMapView)
        myMapView.topAnchor.constraint(equalTo: view.topAnchor).isActive=true
        myMapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive=true
        myMapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive=true
        myMapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 60).isActive=true

        self.view.addSubview(txtFieldSearch)
        txtFieldSearch.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive=true
        txtFieldSearch.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive=true
        txtFieldSearch.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive=true
        txtFieldSearch.heightAnchor.constraint(equalToConstant: 35).isActive=true
        setupTextField(textField: txtFieldSearch, img: #imageLiteral(resourceName: "neopets"))

        binsPreviewView=BinsPreviewView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 190))

        self.view.addSubview(btnMyLocation)
        btnMyLocation.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive=true
        btnMyLocation.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive=true
        btnMyLocation.widthAnchor.constraint(equalToConstant: 50).isActive=true
        btnMyLocation.heightAnchor.constraint(equalTo: btnMyLocation.widthAnchor).isActive=true
    }

    let myMapView: GMSMapView = {
        let v=GMSMapView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()

    let txtFieldSearch: UITextField = {
        let tf=UITextField()
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .white
        tf.layer.borderColor = UIColor.darkGray.cgColor
        tf.placeholder="Search for a location"
        tf.translatesAutoresizingMaskIntoConstraints=false
        return tf
    }()

    let btnMyLocation: UIButton = {
        let btn=UIButton()
        btn.backgroundColor = UIColor.white
        btn.setImage(#imageLiteral(resourceName: "gps"), for: .normal)
        btn.layer.cornerRadius = 25
        btn.clipsToBounds=true
        btn.tintColor = UIColor.gray
        btn.imageView?.tintColor=UIColor.gray
        btn.addTarget(self, action: #selector(btnMyLocationAction), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()

    var binsPreviewView: BinsPreviewView = {
        
        let v=BinsPreviewView()
        return v
        
    }()
    
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered Library")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exit Library")
    }
    
    func contains(_: CLLocationCoordinate2D) -> Bool {
        return true
    }
}

