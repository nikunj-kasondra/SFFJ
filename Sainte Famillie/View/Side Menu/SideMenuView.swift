//
//  SideMenuView.swift
//  OccuCare
//
//  Created by PC23 on 03/08/17.
//  Copyright © 2017 Sapphire. All rights reserved.
//

import UIKit

class SideMenuView: UIView {
    
    //@IBOutlet weak var myAcView: UIView!
    @IBOutlet weak var anciensView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var cantineView: UIView!
    @IBOutlet weak var transportView: UIView!
    @IBOutlet weak var actiView: UIView!
    @IBOutlet weak var newsView: UIView!
    @IBOutlet weak var prodView: UIView!
    
    @IBOutlet weak var annocesView: UIView!
    //@IBOutlet weak var settView: UIView!
    
    @IBOutlet weak var homeView: UIView!
    
    @IBOutlet weak var lblAnnoces: UILabel!
    @IBOutlet weak var lblClassName: UILabel!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var lblHome: UILabel!
    @IBOutlet weak var lblanciens: UILabel!
    @IBOutlet weak var lblinfo: UILabel!
    @IBOutlet weak var lblcantine: UILabel!
    @IBOutlet weak var lbltransport: UILabel!
    @IBOutlet weak var lblacti: UILabel!
    @IBOutlet weak var lblnews: UILabel!
    @IBOutlet weak var lblprod: UILabel!
    //@IBOutlet weak var lblsett: UILabel!
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
        NotificationCenter.default.addObserver(self, selector: #selector(SideMenuView.setLabelMethod), name: NSNotification.Name(rawValue: "setLabel"), object: nil)
    }
    
    // MARK: Set UI
    func setLabelMethod() {
        lblUser.text = "HI, GUEST"
        lblClassName.text = ""
    }
    
    func setUI() {
        
        self.frame = CGRect(x: -(UIScreen.main.bounds.size.width - SideMenuView.menuSize), y: 0, width: UIScreen.main.bounds.size.width - SideMenuView.menuSize, height: UIScreen.main.bounds.size.height)
        SideMenuView.sideMenu = self
        
        SideMenuView.trasparentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        SideMenuView.trasparentView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
        //tblSideMenu.register(UINib(nibName: "SideMenuCell", bundle: nil), forCellReuseIdentifier: "newCell")
        addTapGesture()
        addSwipeGesture()
        if let login = UserDefaults.standard.object(forKey: "AlreadyLogin"){
            print(login)
            let flag = UserDefaults.standard.object(forKey: "AlreadyLogin") as! String
            if flag == "S" {
                lblUser.text = UserDefaults.standard.value(forKey: "name") as? String
                lblClassName.text = UserDefaults.standard.value(forKey: "role") as? String
                //settView.isHidden = false
                //myAcView.isHidden = false
                
            } else if flag == "P" {
                let retriveArrayData = UserDefaults.standard.object(forKey:  "parentArr") as? NSData
                
                let arr = NSKeyedUnarchiver.unarchiveObject(with: retriveArrayData as! Data) as? NSArray
                print(arr)
                //let arr = UserDefaults.standard.value(forKey: "parentArr") as! NSArray
                lblUser.text = (arr?.value(forKey: "FullName") as! NSArray).object(at: 0) as? String
                lblClassName.text = (arr?.value(forKey: "ClassId") as! NSArray).object(at: 0) as? String
            } else if flag == "T"{
                lblUser.text = UserDefaults.standard.value(forKey: "name") as? String
                
            }else {
                lblUser.text = "HI, GUEST"
                lblClassName.text = ""
                //settView.isHidden = true
                //myAcView.isHidden = true
            }
            
        } else {
            lblUser.text = "HI, GUEST"
            lblClassName.text = ""
            //settView.isHidden = true
        }
        
        switch SideMenuView.btnIndex {
        case 0:
            DispatchQueue.main.async {
                self.lblHome.textColor = UIColor.init(red: 63/255, green: 81/255, blue: 181/255, alpha: 1.0)
                self.homeView.backgroundColor = UIColor.init(red: 239.0/255, green: 239.0/255, blue: 239.0/255, alpha: 1.0)
            }
        case 1:
            DispatchQueue.main.async {
               self.lblanciens.textColor = UIColor.init(red: 63/255, green: 81/255, blue: 181/255, alpha: 1.0)
               self.anciensView.backgroundColor = UIColor.init(red: 239.0/255, green: 239.0/255, blue: 239.0/255, alpha: 1.0)
            }
        case 2:
            DispatchQueue.main.async {
                self.lblinfo.textColor = UIColor.init(red: 63/255, green: 81/255, blue: 181/255, alpha: 1.0)
                self.infoView.backgroundColor = UIColor.init(red: 239.0/255, green: 239.0/255, blue: 239.0/255, alpha: 1.0)
            }
        case 4:
            DispatchQueue.main.async {
                self.lblcantine.textColor = UIColor.init(red: 63/255, green: 81/255, blue: 181/255, alpha: 1.0)
                self.cantineView.backgroundColor = UIColor.init(red: 239.0/255, green: 239.0/255, blue: 239.0/255, alpha: 1.0)
            }
        case 3:
            DispatchQueue.main.async {
                self.lbltransport.textColor = UIColor.init(red: 63/255, green: 81/255, blue: 181/255, alpha: 1.0)
                self.transportView.backgroundColor = UIColor.init(red: 239.0/255, green: 239.0/255, blue: 239.0/255, alpha: 1.0)
            }
        case 5:
            DispatchQueue.main.async {
                self.lblAnnoces.textColor = UIColor.init(red: 63/255, green: 81/255, blue: 181/255, alpha: 1.0)
                self.annocesView.backgroundColor = UIColor.init(red: 239.0/255, green: 239.0/255, blue: 239.0/255, alpha: 1.0)
            }
        case 6:
            DispatchQueue.main.async {
                self.lblacti.textColor = UIColor.init(red: 63/255, green: 81/255, blue: 181/255, alpha: 1.0)
                self.actiView.backgroundColor = UIColor.init(red: 239.0/255, green: 239.0/255, blue: 239.0/255, alpha: 1.0)
            }
        case 7:
            DispatchQueue.main.async {
                self.lblnews.textColor = UIColor.init(red: 63/255, green: 81/255, blue: 181/255, alpha: 1.0)
                self.newsView.backgroundColor = UIColor.init(red: 239.0/255, green: 239.0/255, blue: 239.0/255, alpha: 1.0)
            }
        case 8:
            DispatchQueue.main.async {
                self.lblprod.textColor = UIColor.init(red: 63/255, green: 81/255, blue: 181/255, alpha: 1.0)
                self.prodView.backgroundColor = UIColor.init(red: 239.0/255, green: 239.0/255, blue: 239.0/255, alpha: 1.0)
            }
        case 9:
            DispatchQueue.main.async {
                //self.lblsett.textColor = UIColor.init(red: 63/255, green: 81/255, blue: 181/255, alpha: 1.0)
                //self.settView.backgroundColor = UIColor.init(red: 239.0/255, green: 239.0/255, blue: 239.0/255, alpha: 1.0)
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
            SideMenuView.sideMenu.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - menuSize, height: UIScreen.main.bounds.size.height)
//            toView.frame = CGRect(x: SideMenuView.sideMenu.frame.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }
        
    }
    
    // MARK: Close sidemenu
    
    static func close(toView: UIView) {
        
        SideMenuView.isOpen = false
        SideMenuView.trasparentView.removeFromSuperview()
        
        UIView.animate(withDuration: 0.3) {
            SideMenuView.sideMenu.frame = CGRect(x: -(UIScreen.main.bounds.size.width - SideMenuView.menuSize), y: 0, width: UIScreen.main.bounds.size.width - SideMenuView.menuSize, height: UIScreen.main.bounds.size.height)
//            toView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }
        
    }
    
    
    @IBAction func btnHomeClicked(_ sender: Any) {
        SideMenuView.close(toView: SideMenuView.toView)
        let VC = Common.storyboard.instantiateViewController(withIdentifier: "DashboardController")
        self.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
    }
    
    
    @IBAction func btnSettingClicked(_ sender: Any) {
        SideMenuView.close(toView: SideMenuView.toView)
        UserDefaults.standard.set("N", forKey: "AlreadyLogin")
        lblUser.text = "HI, GUEST"
        lblClassName.text = ""
        //settView.isHidden = true
//        let VC = Common.storyboard.instantiateViewController(withIdentifier: "AnciensController")
//        self.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
    }
    @IBAction func btnProdClicked(_ sender: Any) {
        SideMenuView.close(toView: SideMenuView.toView)
        let VC = Common.storyboard.instantiateViewController(withIdentifier: "ProductionController")
        self.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
    }
    @IBAction func btnNewsClicked(_ sender: Any) {
        SideMenuView.close(toView: SideMenuView.toView)
        let VC = Common.storyboard.instantiateViewController(withIdentifier: "NewsController")
        self.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
    }
    @IBAction func btnActivityClicked(_ sender: Any) {
        SideMenuView.close(toView: SideMenuView.toView)
        let VC = Common.storyboard.instantiateViewController(withIdentifier: "ActivityController")
        self.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
    }
    @IBAction func btnTransportClicke(_ sender: Any) {
        SideMenuView.close(toView: SideMenuView.toView)
        let VC = Common.storyboard.instantiateViewController(withIdentifier: "TransportController")
        self.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
    }
    @IBAction func btnCantineClicked(_ sender: Any) {
        SideMenuView.close(toView: SideMenuView.toView)
        let VC = Common.storyboard.instantiateViewController(withIdentifier: "CantineController")
        self.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
    }
    
    @IBAction func btnAnnocesClicked(_ sender: Any) {
        SideMenuView.close(toView: SideMenuView.toView)
        let VC = Common.storyboard.instantiateViewController(withIdentifier: "AnnonceVC")
        self.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
    }
    
    @IBAction func btnInfoClicked(_ sender: Any) {
        SideMenuView.close(toView: SideMenuView.toView)
        let VC = Common.storyboard.instantiateViewController(withIdentifier: "LeCollegeController")
        self.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
    }
    @IBAction func btnAniciensClicked(_ sender: Any) {
        SideMenuView.close(toView: SideMenuView.toView)
        let VC = Common.storyboard.instantiateViewController(withIdentifier: "AnciensController")
        self.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
    }
    
    @IBAction func btnMyAccountClicked(_ sender: Any) {
        SideMenuView.close(toView: SideMenuView.toView)
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
    

}

