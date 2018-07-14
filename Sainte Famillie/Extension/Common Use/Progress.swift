//
//  Progress.swift
//  OccuCare
//
//  Created by PC23 on 01/08/17.
//  Copyright © 2017 Sapphire. All rights reserved.
//

import UIKit
import MBProgressHUD

class Progress: NSObject {
    class func show(toView: UIView) {
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: toView, animated: true)
        }
    }
    
    class func hide(toView: UIView) {
        DispatchQueue.main.async {
            MBProgressHUD.hideAllHUDs(for: toView, animated: true)
        }
    }
}
