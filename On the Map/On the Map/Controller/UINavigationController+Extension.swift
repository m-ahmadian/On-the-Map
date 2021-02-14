//
//  UINavigationController+Extension.swift
//  On the Map
//
//  Created by Mehrdad on 2021-02-14.
//  Copyright © 2021 Udacity. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    func popViewController(viewController: UIViewController, completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popViewController(animated: true)
        CATransaction.commit()
    }
}
