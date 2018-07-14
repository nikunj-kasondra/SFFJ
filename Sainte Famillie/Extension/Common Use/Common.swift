//
//  Common.swift
//  OccuCare
//
//  Created by PC23 on 31/07/17.
//  Copyright © 2017 Sapphire. All rights reserved.
//

import UIKit

class Common: NSObject {
    //Application Name
    static var appName: String = "Occucare"
    
    //Server Path For API
    //static var serverURL: String = "http://192.168.1.135:9900"
    //static var serverURL: String = "http://192.168.1.113:9900"
    static var serverURL: String = "https://adani.occucare.co.in"
    //API Header
    static let header: [String : String] = ["AuthenticationKey": "Occucare@123"]
    
    //API Header
    static let token: String = "Occucare@123"
    
    //Organization Identity
    
    static let OrgId: NSNumber = 3001
    
    //Storyboard
    static var storyboard: UIStoryboard = UIStoryboard()
    
    //Navigation Controller
    static var navigationController: UINavigationController = UINavigationController()
}
extension String {
    
    //Validate Email
    var isValidEmail: Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
}
