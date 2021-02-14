//
//  UIViewController+Extension.swift
//  On the Map
//
//  Created by Mehrdad on 2021-02-03.
//  Copyright © 2021 Udacity. All rights reserved.
//

import UIKit

extension UIViewController {
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        OnTheMapClient.logout {
            print("Successfully logged out")
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
