//
//  LoginViewController.swift
//  On the Map
//
//  Created by Mehrdad on 2021-01-31.
//  Copyright © 2021 Udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: LoginTextField!
    @IBOutlet weak var passwordTextField: LoginTextField!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }
    
    
    
    // MARK: - Actions
    
    @IBAction func loginTapped(_ sender: Any) {
        OnTheMapClient.createSessionId(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleSessionResponse(success:error:))
    }
    
    
    @IBAction func signUp(_ sender: Any) {
        UIApplication.shared.open(OnTheMapClient.Endpoins.signUp.url, options: [:], completionHandler: nil)
    }
    
    
    
    
    // MARK: - Helper Methods
    
    func handleSessionResponse(success: Bool, error: Error?) {
        if success {
            print("successfully logged in")
            print(OnTheMapClient.Auth.sessionId)
            performSegue(withIdentifier: "completeLogin", sender: nil)
        }
    }


}

