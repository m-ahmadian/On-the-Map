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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Add Location"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "CANCEL", style: .plain, target: self, action: #selector(cancel))
        
        OnTheMapClient.getUserData(completion: handleUserData(success:error:))
    }
    
    
    // MARK: - Actions
    
    @IBAction func findLocation(_ sender: Any) {
        performSegue(withIdentifier: "addLocation", sender: self)
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
            addLocationVC?.link = self.linkTextField.text ?? ""
        }
        
    }
    
    
    func handleUserData(success: Bool, error: Error?) {
        print("\(OnTheMapClient.Auth.firstName) \(OnTheMapClient.Auth.lastName)")
    }

}
