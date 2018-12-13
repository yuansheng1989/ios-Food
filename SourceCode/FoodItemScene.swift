//
//  FoodItemSceneBaseCD.swift
//  Purpose - Control the "next" scene in the nav Disclosure workflow
//  This is a standard view controller
//  It is within a navigation workflow, with a presenter, and a maybe a successor
//

import UIKit

// Adopt the protocols that are appropriate for this controller (detail, add, etc.)

class FoodItemScene: UIViewController {
    
    // MARK: - Public properties (instance variables)
    
    var m: DataModelManager!
    // Passed-in object, if necessary
    var item: FoodItem!
    
    // MARK: - Outlets (user interface)
    
    //@IBOutlet weak var foodItemName: UILabel!
    @IBOutlet weak var foodItemName: UILabel!
    @IBOutlet weak var foodItemSource: UILabel!
    @IBOutlet weak var foodItemQuantity: UILabel!
    @IBOutlet weak var foodItemLatitude: UILabel!
    @IBOutlet weak var foodItemLongitude: UILabel!
    @IBOutlet weak var foodItemLocation: UILabel!
    @IBOutlet weak var foodItemPhoto: UIImageView!
    @IBOutlet weak var foodItemTimestamp: UILabel!
    

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodItemName.text = item.name
        foodItemQuantity.text = String(item.quantity) + " grams"
        foodItemSource.text = item.source
        foodItemLatitude.text = "Latitude: " + String(format: "%.4f", item.lat)
        foodItemLongitude.text = "Longitude: " + String(format: "%.4f", item.lon)
        foodItemLocation.text = item.location
        
        let df = DateFormatter()
        df.dateStyle = .long
        df.timeStyle = .short
        foodItemTimestamp.text = df.string(from: item.timestamp!)
        
        // From Data to UIImage
        // Attempt to create a UIImage representation of the photo
        if let temp = item.photo {
            let photo = UIImage(data: temp)
            foodItemPhoto.image = photo
        }
    }
    
    // MARK: - Actions (user interface)
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        // Add "if" blocks to cover all the possible segues
        // One for each workflow (navigation) or task segue
        
        // A workflow segue is managed by the current nav controller
        // A task segue goes to a scene that's managed by a NEW nav controller
        // So there's a difference in how we get a reference to the next controller
        
        // Sample workflow segue code...
        /*
        if segue.identifier == "toWorkflowScene" {
            
            // Your customized code goes here,
            // but here is some sample/starter code...
            
            // Get a reference to the next controller
            // Next controller is managed by the current nav controller
            let vc = segue.destination as! FoodItemScene
            
            // Fetch and prepare the data to be passed on
            let selectedData = item
            
            // Set other properties
            vc.item = selectedData
            vc.title = selectedData?.name
            // Pass on the data model manager, if necessary
            //vc.m = m
            // Set the delegate, if configured
            //vc.delegate = self
        }
        */
        
        // Sample task segue code...
        /*
        if segue.identifier == "toTaskScene" {
            
            // Your customized code goes here,
            // but here is some sample/starter code...
            
            // Get a reference to the next controller
            // Next controller is embedded in a new navigation controller
            // so we must go through it
            let nav = segue.destination as! UINavigationController
            let vc = nav.viewControllers[0] as! FoodItemDetail
            
            // Fetch and prepare the data to be passed on
            let selectedData = item
            
            // Set other properties
            vc.item = selectedData
            vc.title = selectedData?.name
            // Pass on the data model manager, if necessary
            //vc.m = m
            // Set the delegate, if configured
            //vc.delegate = self
        }
        */
        
    }
    
}
