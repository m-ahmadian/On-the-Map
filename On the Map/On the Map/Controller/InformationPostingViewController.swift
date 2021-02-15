//
//  InformationPostingViewController.swift
//  On the Map
//
//  Created by Mehrdad on 2021-02-05.
//  Copyright © 2021 Udacity. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    
    
    // MARK: - Properties
    lazy var coordinate = CLLocationCoordinate2D()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Add Location"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "CANCEL", style: .plain, target: self, action: #selector(cancel))
        
        OnTheMapClient.getUserData(completion: handleUserData(success:error:))
    }
    
    
    // MARK: - Actions
    
    @IBAction func findLocation(_ sender: Any) {
        getCoordinate(addressString: locationTextField.text ?? "", completionHandler: handleGetCoordinate(coordinate:error:))
    }
    
    
    // MARK: - Helper Methods
    
    @objc func cancel() {
//        self.navigationController?.popToRootViewController(animated: true)
        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //
        if segue.identifier == "addLocation" {
            let addLocationVC = segue.destination as? AddLocationViewController
            addLocationVC?.location = self.locationTextField.text ?? ""
            addLocationVC?.coordinate = self.coordinate
            addLocationVC?.link = self.linkTextField.text ?? ""
        }
        
    }
    
    
    func handleUserData(success: Bool, error: Error?) {
        print("\(OnTheMapClient.Auth.firstName) \(OnTheMapClient.Auth.lastName)")
    }
    
    
    
    func getCoordinate(addressString : String,
                       completionHandler: @escaping (CLLocationCoordinate2D, Error?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                
                    DispatchQueue.main.async {
                        completionHandler(location.coordinate, nil)
                    }
                    return
                }
            }
            
            DispatchQueue.main.async {
                completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
            }
        }
    }
    
    
    func handleGetCoordinate(coordinate: CLLocationCoordinate2D, error: Error?) {
        if error == nil {
            self.coordinate = coordinate
            performSegue(withIdentifier: "addLocation", sender: self)

        }
    }

}
