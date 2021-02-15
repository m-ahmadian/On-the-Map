//
//  AddLocationViewController.swift
//  On the Map
//
//  Created by Mehrdad on 2021-02-05.
//  Copyright © 2021 Udacity. All rights reserved.
//

import UIKit
import MapKit

protocol AddLocationViewControllerDelegate {
    func dismissViewController(controller: UIViewController)
}

class AddLocationViewController: UIViewController, AddLocationViewControllerDelegate {
    
    // AddLocationViewController Delegate Method
    func dismissViewController(controller: UIViewController) {
        controller.dismiss(animated: true) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    
    // MARK: - Properties
    var location: String!
    var link: String!
    var coordinate: CLLocationCoordinate2D!
    
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpMapView(coordinate: coordinate)
    }
    
    
    // MARK: - Actions
    @IBAction func finish(_ sender: Any) {
        OnTheMapClient.postStudentLocation(mapString: location, mediaURL: link, latitude: coordinate.latitude, longitude: coordinate.longitude, completion: handlePostLocation(success:error:))
    }
    
    
    
    // MARK: - Helper Methods
    
    func setUpMapView(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(OnTheMapClient.Auth.firstName) \(OnTheMapClient.Auth.lastName)"
        annotation.subtitle = link
        
        //            let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: CLLocationDistance(exactly: 5000)!, longitudinalMeters: CLLocationDistance(exactly: 5000)!)
        //            let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
        
        self.mapView.setRegion(region, animated: true)
        self.mapView.addAnnotation(annotation)
        self.mapView.reloadInputViews()
    }
    
    
    
    func handlePostLocation(success: Bool, error: Error?) {
        if success {
            print("Posted Student Location Successfully")
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                
//                self.dismissViewController(controller: self)
                
//                self.navigationController?.popViewController(viewController: self, completion: {
//                    self.dismiss(animated: true, completion: nil)
//                })
            }
        } else {
            print("Posting Student Location Failed!")
        }
    }

}


extension AddLocationViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            pinView?.canShowCallout = true
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!)
            }
        }
    }
}
