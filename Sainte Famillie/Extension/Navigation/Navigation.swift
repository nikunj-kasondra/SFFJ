//
//  Navigation.swift
//  OccuCare
//
//  Created by PC23 on 29/07/17.
//  Copyright © 2017 Sapphire. All rights reserved.
//

import UIKit

class Navigation: NSObject {
    
    // MARK: use for screen navigation
    /// Use for screen navigation one screen to another screen
    /// - Parameters:
    ///   - destinationVC: Pass viewcontroller object where you want to navigate
    ///   - navigationsController: Pass navigation controller object
    ///   - isAnimated: If you want navigation animation 
    
    static func push_POP_to_ViewController(destinationVC: UIViewController, navigationsController: UINavigationController, isAnimated: Bool) {
        var vcFound: Bool = false
        let viewControllers: NSArray = (navigationsController.viewControllers as NSArray)
        var indexofVC: NSInteger = 0
        for  vc  in viewControllers {
            if (vc as AnyObject).nibName == (destinationVC.nibName) {
                vcFound = true
                break
            } else {
                indexofVC += 1
            }
        }
        if vcFound == true {
            DispatchQueue.main.async {
                navigationsController .popToViewController(viewControllers.object(at: indexofVC) as! UIViewController, animated: isAnimated)
            }
        } else {
            DispatchQueue.main.async {
                navigationsController .pushViewController(destinationVC, animated: isAnimated)
            }
        }
    }

}
