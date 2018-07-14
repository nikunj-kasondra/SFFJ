//
//  SideMenuView.swift
//  OccuCare
//
//  Created by PC23 on 03/08/17.
//  Copyright © 2017 Sapphire. All rights reserved.
//

import UIKit

class SideMenuView: UIView {

    
    @IBOutlet weak var passView: UIView!
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblHome: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    static var sideMenu: UIView = UIView()
    static var isOpen = Bool()
    static var menuSize: CGFloat = 60
    static var trasparentView = UIView()
    static var toView = UIView()
    static var btnIndex: Int = 0
    @IBOutlet weak var tblSideMenu: UITableView!
    
    override func draw(_ rect: CGRect) {
        setUI()
    }
    
    // MARK: Set UI
    
    func setUI() {
        
        self.frame = CGRect(x: -(Device.screenWidth - SideMenuView.menuSize), y: 0, width: Device.screenWidth - SideMenuView.menuSize, height: Device.screenHeight)
        SideMenuView.sideMenu = self
        
        SideMenuView.trasparentView.frame = CGRect(x: 0, y: 0, width: Device.screenWidth, height: Device.screenHeight)
        SideMenuView.trasparentView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
        //tblSideMenu.register(UINib(nibName: "SideMenuCell", bundle: nil), forCellReuseIdentifier: "newCell")
        addTapGesture()
        addSwipeGesture()
        self.lblUserName.text = Constant.empDetail["UserFullName"]! as! String
        switch SideMenuView.btnIndex {
        case 0:
            DispatchQueue.main.async {
                self.lblHome.textColor = UIColor.init(red: 152.0/255, green: 51.0/255, blue: 102.0/255, alpha: 1.0)
                self.homeView.backgroundColor = UIColor.init(red: 239.0/255, green: 239.0/255, blue: 239.0/255, alpha: 1.0)
            }
        case 1:
            DispatchQueue.main.async {
               self.lblPassword.textColor = UIColor.init(red: 152.0/255, green: 51.0/255, blue: 102.0/255, alpha: 1.0)
               self.passView.backgroundColor = UIColor.init(red: 239.0/255, green: 239.0/255, blue: 239.0/255, alpha: 1.0)
            }
        
        default:
            break
        }
        
    }
    
    // MARK: Add Tap gesture
    
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(onTap))
        SideMenuView.trasparentView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: Add Swipe gesture
    
    func addSwipeGesture() {
        
        let swipeRight = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeRightSide))
        swipeRight.direction = .right
        SideMenuView.toView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer.init(target: self, action: #selector(onTap))
        swipeLeft.direction = .left
        SideMenuView.toView.addGestureRecognizer(swipeLeft)
        
    }
    
    // MARK: Right swipe on menu call
    
    func swipeRightSide() {
        SideMenuView.open(toView: SideMenuView.toView)
    }
    
    // MARK: Tap on menu call
    
    func onTap() {
        SideMenuView.close(toView: SideMenuView.toView)
    }
    
    // MARK: Add sidemenu
    
    static func add(toVC: UIViewController, toView: UIView) {
        
        let sideMenuView = Bundle.main.loadNibNamed("SideMenu", owner: self, options: nil)?[0] as! SideMenuView
        UIApplication.shared.keyWindow!.addSubview(sideMenuView)
        SideMenuView.toView = toView
        
    }
   
    
    // MARK: Open sidemenu
    
    static func open(toView: UIView) {
        
        SideMenuView.isOpen = true
        toView.addSubview(SideMenuView.trasparentView)
        UIView.animate(withDuration: 0.3) {
            SideMenuView.sideMenu.frame = CGRect(x: 0, y: 0, width: Device.screenWidth - menuSize, height: Device.screenHeight)
            toView.frame = CGRect(x: SideMenuView.sideMenu.frame.width, y: 0, width: Device.screenWidth, height: Device.screenHeight)
        }
        
    }
    
    // MARK: Close sidemenu
    
    static func close(toView: UIView) {
        
        SideMenuView.isOpen = false
        SideMenuView.trasparentView.removeFromSuperview()
        
        UIView.animate(withDuration: 0.3) {
            SideMenuView.sideMenu.frame = CGRect(x: -(Device.screenWidth - SideMenuView.menuSize), y: 0, width: Device.screenWidth - SideMenuView.menuSize, height: Device.screenHeight)
            toView.frame = CGRect(x: 0, y: 0, width: Device.screenWidth, height: Device.screenHeight)
        }
        
    }
    
    
    @IBAction func btnHomeClicked(_ sender: Any) {
        SideMenuView.close(toView: SideMenuView.toView)
        let VC = Common.storyboard.instantiateViewController(withIdentifier: "DashBoardVC")
        self.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
    }
    
    
    @IBAction func btnChangePasswordClicked(_ sender: Any) {
        SideMenuView.close(toView: SideMenuView.toView)
        let VC = Common.storyboard.instantiateViewController(withIdentifier: "LoggedChangePassVC")
        self.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
    }
    
    
    func push_POP_to_ViewController(destinationVC: UIViewController, navigationsController: UINavigationController, isAnimated: Bool) {
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
                navigationsController .popToViewController(viewControllers.object(at: indexofVC) as! UIViewController, animated: false)
            }
        } else {
            DispatchQueue.main.async {
                navigationsController .pushViewController(destinationVC, animated: true)
            }
        }
    }
    
    @IBAction func btnLogoutClicked(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "UserAlreadyLogin")
        SideMenuView.close(toView: SideMenuView.toView)
        let VC = Common.storyboard.instantiateViewController(withIdentifier: "LoginVC")
        self.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
    }

}

