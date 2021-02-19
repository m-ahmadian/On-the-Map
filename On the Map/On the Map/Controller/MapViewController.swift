//
//  MapViewController.swift
//  On the Map
//
//  Created by Mehrdad on 2021-02-03.
//  Copyright © 2021 Udacity. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
//    var annotations = [MKPointAnnotation]()
//    lazy var locationsArray = [Results]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        OnTheMapClient.getStudentLocations(completion: handleStudentLocationsResponse(locations:error:))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Actions
    @IBAction func refreshData(_ sender: Any) {
        refreshUI(true)
        OnTheMapClient.getStudentLocations(completion: handleStudentLocationsResponse(locations:error:))
    }
    
    
    
    // MARK: - Helper Methods
    
    func handleStudentLocationsResponse(locations: [Results], error: Error?) {
        if error != nil {
            return
        } else {

            StudentModel.locations = locations
            mapView.removeAnnotations(mapView.annotations)

            var annotations = [MKPointAnnotation]()

            for location in StudentModel.locations {
                let lat = CLLocationDegrees(String(format: "%f", location.latitude))!
                let long = CLLocationDegrees(String(format: "%f", location.longitude))!
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)

                let first = location.firstName
                let last = location.lastName
                let mediaURL = location.mediaURL

                let annotaion = MKPointAnnotation()
                annotaion.coordinate = coordinate
                annotaion.title = "\(first ?? "") \(last ?? "")"
                annotaion.subtitle = mediaURL

                annotations.append(annotaion)
            }

            self.mapView.addAnnotations(annotations)
            refreshUI(false)
        }
    }
    
    
    func refreshUI(_ refreshing: Bool) {
        if refreshing {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

}


// MARK: - MapViewController Extension
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "location"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            pinView?.canShowCallout = true
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView?.annotation = annotation
        }
        
        pinView?.displayPriority = .required
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
}
