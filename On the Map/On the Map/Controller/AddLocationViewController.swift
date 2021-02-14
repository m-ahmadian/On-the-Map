//
//  AddLocationViewController.swift
//  On the Map
//
//  Created by Mehrdad on 2021-02-05.
//  Copyright © 2021 Udacity. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    
    // MARK: - Properties
    var location: String!
    var link: String!
    lazy var latitude: Double = 0
    lazy var longitude: Double = 0
    
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCoordinate(addressString: location, completionHandler: handleGetCoordinate(coordinate:error:))
    }
    
    
    // MARK: - Actions
    @IBAction func finish(_ sender: Any) {
        OnTheMapClient.postStudentLocation(mapString: location, mediaURL: link, latitude: latitude, longitude: longitude, completion: handlePostLocation(success:error:))
        
    }
    
    
    
    // MARK: - Helper Methods
    
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
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            annotation.title = "\(OnTheMapClient.Auth.firstName) \(OnTheMapClient.Auth.lastName)"
            annotation.subtitle = link
            
//            let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: CLLocationDistance(exactly: 5000)!, longitudinalMeters: CLLocationDistance(exactly: 5000)!)
//            let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
            
            self.mapView.setRegion(region, animated: true)
            self.mapView.addAnnotation(annotation)
            self.mapView.reloadInputViews()
        }
    }
    
    func handlePostLocation(success: Bool, error: Error?) {
        
        if success {
            print("Posted Student Location Successfully")
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
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
