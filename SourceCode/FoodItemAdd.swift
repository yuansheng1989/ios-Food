//
//  FoodItemAddCD.swift
//  Purpose - Handles the "add item" workflow
//  This is a standard view controller, modally-presented
//

//  This controller's scene (on the storyboard) must be embedded in a navigation controller

//  This functionality needs a delegate (choose a meaningful name)
//  Therefore, we declare a protocol
//  Sample method implementations are at the bottom of this file

import UIKit
// Import the location services library
import CoreLocation

protocol AddFoodItemDelegate: class {
    
    func addTaskDidCancel(_ controller: UIViewController)
    
    func addTaskDidSave(_ controller: UIViewController)
}

class FoodItemAdd: UIViewController, CLLocationManagerDelegate, SelectFoodItemDelegate {
    
    // MARK: - Instance variables
    
    weak var delegate: AddFoodItemDelegate?
    
    // These are the important variables:
    // "location" holds the GPS coordinate
    // "placemarkText" holds its address as a string
    var locationManager = CLLocationManager()
    var location: CLLocation?
    var locationRequests: Int = 0
    var geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var placemarkText = "(location not available)"
    
    var photo: UIImage?
    
    var m: DataModelManager!
    
    // MARK: - Outlets (user interface)
    
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var foodItemName: UITextField!
    @IBOutlet weak var foodItemSource: UITextField!
    @IBOutlet weak var foodItemNotes: UITextField!
    @IBOutlet weak var foodItemQuantity: UISegmentedControl!
    @IBOutlet weak var pickedPhoto: UIImageView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the location
        getLocation()
    }
    
    // Make the first/desired text field active and show the keyboard
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        foodItemName.becomeFirstResponder()
    }
    
    
    // MARK: - Private methods
    private func getLocation() {
        
        // These two statements setup and configure the location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10.0
        
        // Determine whether the app can use location services
        let authStatus = CLLocationManager.authorizationStatus()
        
        // If the app user has never been asked before, then ask
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        // If the app user has previously denied location services, do this
        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
            return
        }
        
        // If we are here, it means that we can use location services
        // This statement starts updating its location
        locationManager.startUpdatingLocation()
    }
    
    // Respond to a previously-denied request to use location services
    private func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Settings.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // Build a nice string from a placemark
    // If you want a different format, do it
    private func makePlacemarkText(from placemark: CLPlacemark) -> String {
        
        var s = ""
        s.append(placemark.subThoroughfare!)
        s.append(" \(placemark.thoroughfare!)")
        s.append(", \(placemark.locality!) \(placemark.administrativeArea!)")
        s.append(", \(placemark.postalCode!) \(placemark.country!)")
        
        return s
    }
    
    // MARK: - Delegate methods
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        // When location services is requested for the first time,
        // the app user is asked for permission to use location services
        // After the permission is determined, this method is called by the location manager
        // If the permission is granted, we want to start updating the location
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\nUnable to use location services: \(error)")
    }
    
    // This is called repeatedly by the iOS runtime,
    // as the location changes and/or the accuracy improves
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Here is how you can configure an arbitrary limit to the number of updates
        if locationRequests > 10 { locationManager.stopUpdatingLocation() }
        
        // Save the new location to the class instance variable
        location = locations.last!
        
        // Info to the programmer
        print("\nUpdate successful: \(location!)")
        print("\nLatitude \(location?.coordinate.latitude ?? 0)\nLongitude \(location?.coordinate.longitude ?? 0)")
        
        // Do the reverse geocode task
        // It takes a function as an argument to completionHandler
        geocoder.reverseGeocodeLocation(location!, completionHandler: { placemarks, error in
            
            // We're looking for a happy response, if so, continue
            if error == nil, let p = placemarks, !p.isEmpty {
                
                // "placemarks" is an array of CLPlacemark objects
                // For most geocoding requests, the array has only one value,
                // so we will use the last (most recent) value
                // Format and save the text from the placemark into the class instance variable
                self.placemarkText = self.makePlacemarkText(from: p.last!)
                // Info to the programmer
                print("\n\(self.placemarkText)")
            }
        })
        
        locationRequests += 1
    }
    
    func selectTaskDidCancel(_ controller: UIViewController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    // Use the correct type for the "item"
    func selectTask(_ controller: UIViewController, didSelect item: NdbSearchListItem) {
        
        // Do something with the item
        foodItemName.text = item.name
        foodItemSource.text = item.manu
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Actions (user interface)
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        // Call into the delegate
        delegate?.addTaskDidCancel(self)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        view.endEditing(false)
        errorMessage.text?.removeAll()
        
        // Validate the data before saving
        
        if foodItemName.text!.isEmpty {
            errorMessage.text = "Invalid name"
            return
        }
        
        if foodItemSource.text!.isEmpty {
            errorMessage.text = "Invalid source"
            return
        }
        
        if foodItemNotes.text!.isEmpty {
            errorMessage.text = "Invalid notes"
            return
        }
        
        var quantity: Int = 0
        quantity = Int(foodItemQuantity.titleForSegment(at: foodItemQuantity.selectedSegmentIndex)!)!
        
        // If we are here, the data passed the validation tests
        
        // Tell the user what we're doing
        errorMessage.text = "Attempting to save..."
        
        // Make an object, configure and save
        if let newItem = m.foodItem_CreateItem() {
            
            newItem.name = foodItemName.text
            newItem.source = foodItemSource.text
            newItem.notes = foodItemNotes.text
            newItem.quantity = Int32(quantity)
            
            // Save current date
            newItem.timestamp = Date()
            
            // Save coordinate and location
            if let lat = location?.coordinate.latitude {
                newItem.lat = Double(lat)
            }
            if let lon = location?.coordinate.longitude {
                newItem.lon = Double(lon)
            }
            newItem.location = self.placemarkText
            
            // From UIImage to Data
            // Attempt to create a Data representation of the photo
            if let temp = photo {
                guard let imageData  = UIImageJPEGRepresentation(temp, 1.0) else {
                    errorMessage.text = "Cannot save photo"
                    return
                }
                newItem.photo = imageData
            }
            
            // From UIImage to Data
            // Attempt to create a Data representation of the photoThumbnail
            if let temp = photo?.getThumbnailImage(25.0) {
                guard let imageData  = UIImageJPEGRepresentation(temp, 1.0) else {
                    errorMessage.text = "Cannot save photoThumbnail"
                    return
                }
                newItem.photoThumbnail = imageData
            }
            
            m.ds_save()
        }

        // Call into the delegate
        delegate?.addTaskDidSave(self)
    }
    
    @IBAction func getPhoto(_ sender: UIButton) {
        getPhotoWithCameraOrPhotoLibrary()
    }
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "toFoodItemSearchList" {
            
            // Validate the data from the user interface...
            // If the food item name text field is empty,
            //   then show an error message,
            //   and return "false"
            // However, if it is not empty,
            //   call the manager's "foodItem_Search(searchTerms:)" method
            
            if foodItemName.text == "" {
                return false
            } else {
                m.foodItem_Search(foodItemName.text!)
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFoodItemSearchList" {
            // Your customized code goes here,
            // but here is some sample/starter code...
            
            // Get a reference to the next controller
            // Next controller is embedded in a new navigation controller
            // so we must go through it
            let nav = segue.destination as! UINavigationController
            let vc = nav.viewControllers[0] as! FoodItemSearchList
            
            // Fetch and prepare the data to be passed on
            //let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            //let selectedData = frc.object(at: indexPath!)
            
            // Set other properties
            //vc.item = selectedData
            vc.title = "Search"
            // Pass on the data model manager, if necessary
            vc.m = m
            // Set the delegate, if configured
            vc.delegate = self
        }
    }
}

// Sample delegate method implementations
// Copy to the presenting controller's "Lifecycle" area

/*
 func addTaskDidCancel(_ controller: UIViewController) {
 
 dismiss(animated: true, completion: nil)
 }
 
 func addTaskDidSave(_ controller: UIViewController) {
 
 dismiss(animated: true, completion: nil)
 }
 */
