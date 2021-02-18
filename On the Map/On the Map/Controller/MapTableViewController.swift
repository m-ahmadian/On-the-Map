//
//  MapTableViewController.swift
//  On the Map
//
//  Created by Mehrdad on 2021-02-04.
//  Copyright © 2021 Udacity. All rights reserved.
//

import UIKit
import MapKit

class MapTableViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    
    
    // MARK: - Properties
    lazy var locations = [Results]()
    
    
    // MARK: - View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        OnTheMapClient.getStudentLocations(completion: handleStudentLocationsResponse(locations:error:))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            self.locations = locations
            UIView.transition(with: tableView, duration: 1.0, options: .transitionCrossDissolve, animations: {
                self.tableView.reloadData()
            }, completion: nil)
            refreshUI(false)
        }
    }
    
    
    func refreshUI(_ refreshing: Bool) {
        if refreshing {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        activityView.isHidden = !refreshing
    }
    
    

    // MARK: - TableView Delegate & DataSource Methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let location = locations[indexPath.row]
        
        cell.textLabel?.text = "\(location.firstName) \(location.lastName)"
        cell.detailTextLabel?.text = location.mediaURL
        cell.imageView?.image = UIImage(named: "icon_pin")

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLocation = locations[indexPath.row]
        
        let toOpen = selectedLocation.mediaURL
        UIApplication.shared.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
    }
    
}
