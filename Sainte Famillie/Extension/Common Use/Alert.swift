//
//  Alert.swift
//  Occucare
//
//  Created by PC23 on 28/07/17.
//  Copyright © 2017 Sapphire. All rights reserved.
//

import UIKit
import ReachabilitySwift
class Alert: NSObject {
    
    // MARK: General Alert
    /// Display native alertview
    /// - Parameters:
    ///   - title: Pass alert title as a string
    ///   - message: Pass alert message as a string
    ///   - onVC: On which viewcontroller you want to display
    
    static func show(_ title: String, message: String, onVC: UIViewController) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        DispatchQueue.main.async {
            onVC.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: Request Time Out Alert
    static func requestTimeOut() {
        let alert: UIAlertView = UIAlertView(title: Common.appName, message: "Request time out." as String, delegate: nil, cancelButtonTitle: "Ok")
        DispatchQueue.main.async {
            alert.show()
        }
    }
    
    // MARK: Internal Server Error
    static func internalServerError() {
        let alert: UIAlertView = UIAlertView(title: Common.appName, message:"Internal server error." as String, delegate: nil, cancelButtonTitle: "Ok")
        DispatchQueue.main.async {
            alert.show()
        }
    }
    
    // MARK: Internal Server Error
    static func internetConnectionError() {
        let alert: UIAlertView = UIAlertView(title: Common.appName, message:"Please check your internet connection" as String, delegate: nil, cancelButtonTitle: "Ok")
        DispatchQueue.main.async {
            alert.show()
        }
    }

    
}
