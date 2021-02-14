//
//  LoginButton.swift
//  On the Map
//
//  Created by Mehrdad on 2021-02-01.
//  Copyright © 2021 Udacity. All rights reserved.
//

import UIKit

class LoginButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
        tintColor = UIColor.white
        backgroundColor = UIColor.redForButton
    }
}
