//
//  DashboardController.swift
//  Sainte Famillie
//
//  Created by Rujal on 9/26/17.
//  Copyright © 2017 Nikunj. All rights reserved.
//

import UIKit
import MessageUI

class DashboardController: UIViewController, MFMailComposeViewControllerDelegate,UITextFieldDelegate {

    @IBOutlet weak var lblLogout: UILabel!
    @IBOutlet weak var imgLogout: UIImageView!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var homeCollection: UICollectionView!
    var nameArr = [String]()
    var colorCodeArr = [String]()
    var verMenu:Bool = false
    @IBOutlet weak var dropViewHeight: NSLayoutConstraint!
    @IBOutlet weak var dropViewWidth: NSLayoutConstraint!
    @IBOutlet weak var dropView: UIView!
    var timer = Timer()
    //http://api.sainte-famille.edu.lb/api/sainteemilie/getannoncesnews?newsId=0
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        homeCollection.register(UINib(nibName: "DashBoardCell", bundle: nil), forCellWithReuseIdentifier: "newCell")
        nameArr = ["Le collège","Anciens","Se connecter","Transport","","Cantine","","Annonces","","Activités Extrascolaires","","Nouvelles","","Productions",""]
        
        colorCodeArr = ["#8ac349","#fa8b00","#2d42af","#1e87e4","#fcd839","#9475cd","#FA8B00","#ef6192","#279a42","#2DC5DA","#b968c7","#7AA9F7","#F32B44","#FBD30A","#04519A"]
        Common.storyboard = self.storyboard!
        Common.navigationController = self.navigationController!
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    func updateTimer() {
        if AppDelegate.deviceToken != "" {
            self.timer.invalidate()
            if !Reachability.isConnectedToNetwork() {
                Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
            } else {
                Progress.show(toView: self.view)
                let url = URL(string: "http://api.sainte-famille.edu.lb/api/login/getsavegestuserdeviceid?deviceid=\(AppDelegate.deviceToken)&gcmId=\(AppDelegate.deviceToken)")
                URLSession.shared.dataTask(with: url!, completionHandler: {
                    (data, response, error) in
                    if(error != nil){
                        Progress.hide(toView: self.view)
                        print("error")
                    }else{
                        do{
                            Progress.hide(toView: self.view)
                            let presArr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! Bool
                            print(presArr)
                            
                        }catch let error as NSError{
                            print(error)
                            Alert.show("Sainte Famillie", message: "Something went wrong. Please try again", onVC: self)
                            Progress.hide(toView: self.view)
                        }
                    }
                }).resume()
                
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: View Appear Delegate
    override func viewWillAppear(_ animated: Bool) {
        SideMenuView.btnIndex = 0
        SideMenuView.add(toVC: self, toView: self.view)
        dropView.isHidden = true
        dropViewWidth.constant = 0
        dropViewHeight.constant = 0
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(DashboardController.tapClicked(gesture:)))
        dropView.addGestureRecognizer(tapGesture)
        if let login = UserDefaults.standard.object(forKey: "AlreadyLogin"){
            print(login)
            let flag = UserDefaults.standard.object(forKey: "AlreadyLogin") as! String
            if flag == "P" || flag == "S"{
                lblLogout.isHidden = false
                btnLogout.isHidden = false
                imgLogout.isHidden = false
                nameArr = ["Le collège","Anciens","Ma page","Transport","","Cantine","","Annonces","","Activités Extrascolaires","","Nouvelles","","Productions",""]
            } else if flag == "T" {
                lblLogout.isHidden = false
                btnLogout.isHidden = false
                imgLogout.isHidden = false
                nameArr = ["Le collège","Anciens","Ma page","Transport","","Cantine","","Annonces","","Activités Extrascolaires","","Nouvelles","","Productions",""]
            }else {
                lblLogout.isHidden = true
                btnLogout.isHidden = true
                imgLogout.isHidden = true
                nameArr = ["Le collège","Anciens","Se connecter","Transport","","Cantine","","Annonces","","Activités Extrascolaires","","Nouvelles","","Productions",""]
            }
        } else {
            lblLogout.isHidden = true
            btnLogout.isHidden = true
            imgLogout.isHidden = true
            nameArr = ["Le collège","Anciens","Se connecter","Transport","","Cantine","","Annonces","","Activités Extrascolaires","","Nouvelles","","Productions",""]
        }
        DispatchQueue.main.async {
            self.homeCollection.reloadData()
        }
    }
    func tapClicked(gesture:UITapGestureRecognizer) {
        dropView.isHidden = true
        dropViewWidth.constant = 0
        dropViewHeight.constant = 0
        verMenu = false
    }
    
    @IBAction func btnMenuClicked(_ sender: Any) {
        if !SideMenuView.isOpen {
            
            SideMenuView.open(toView: self.view)
            
        } else {
            
            SideMenuView.close(toView: self.view)
            
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func btnLocateClicked(_ sender: Any) {
        dropView.isHidden = true
        dropViewWidth.constant = 0
        dropViewHeight.constant = 0
        verMenu = false
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "LocateUsController")
        self.navigationController?.pushViewController(VC!, animated: true)
    }
    @IBAction func btnTwitterClicked(_ sender: Any) {
        dropView.isHidden = true
        dropViewWidth.constant = 0
        dropViewHeight.constant = 0
        verMenu = false
        UIApplication.shared.openURL(URL(string: "https://twitter.com/SainteFamilleJ")!)
    }
    @IBAction func btnFbClicked(_ sender: Any) {
        dropView.isHidden = true
        dropViewWidth.constant = 0
        dropViewHeight.constant = 0
        verMenu = false
        UIApplication.shared.openURL(URL(string: "https://www.facebook.com/sffjofficielle/")!)
    }
    @IBAction func btnEmailClicked(_ sender: Any) {
        dropView.isHidden = true
        dropViewWidth.constant = 0
        dropViewHeight.constant = 0
        verMenu = false
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }else {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.setToRecipients(["info@sainte-famille.edu.lb"])
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    @IBAction func btnCallClicked(_ sender: Any) {
        dropView.isHidden = true
        dropViewWidth.constant = 0
        dropViewHeight.constant = 0
        verMenu = false
        let phoneNumber = "+961 3 447674"
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(phoneCallURL as URL)
                }
            }
        }
    }
    
    @IBAction func btnVerticalMenuClicked(_ sender: Any) {
        if !verMenu {
            verMenu = true
            dropView.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                if let login = UserDefaults.standard.object(forKey: "AlreadyLogin"){
                    print(login)
                    let flag = UserDefaults.standard.object(forKey: "AlreadyLogin") as! String
                    if flag == "P" || flag == "S" || flag == "T"{
                        self.dropViewHeight.constant = 345
                        self.dropViewWidth.constant = 240
                    } else {
                        self.dropViewHeight.constant = 295
                        self.dropViewWidth.constant = 240
                    }
                } else {
                    self.dropViewHeight.constant = 295
                    self.dropViewWidth.constant = 240
                }
                
            })
        } else {
            verMenu = false
        }
    }
    
    @IBAction func btnAboutUsClicked(_ sender: Any) {
        dropView.isHidden = true
        dropViewWidth.constant = 0
        dropViewHeight.constant = 0
        verMenu = false
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsController")
        self.navigationController?.pushViewController(VC!, animated: true)
    }
    @IBAction func btnLogoutClicked(_ sender: Any) {
        callLogout()
        
    }
    
    func callLogout() {
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            let url = URL(string: "http://api.sainte-famille.edu.lb/api/login/logoutuser?userName=\(UserDefaults.standard.value(forKey: "Code") as! String)")
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    
                    do{
                        let presArr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! Bool
                        Progress.hide(toView: self.view)
                        if presArr {
                            self.dropView.isHidden = true
                            self.dropViewWidth.constant = 0
                            self.dropViewHeight.constant = 0
                            self.verMenu = false
                            self.lblLogout.isHidden = true
                            self.btnLogout.isHidden = true
                            self.imgLogout.isHidden = true
                            self.nameArr = ["Le collège","Anciens","Se connecter","Transport","","Cantine","","Annonces","","Activités Extrascolaires","","Nouvelles","","Productions",""]
                            
                            UserDefaults.standard.set("N", forKey: "AlreadyLogin")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setLabel"), object: nil)
                            DispatchQueue.main.async {
                                self.homeCollection.reloadData()
                            }
                        }else {
                            Alert.show("Sainte Famillie", message: "Wrong username or password", onVC: self)
                        }
                        
                    }catch let error as NSError{
                        print(error)
                        Alert.show("Sainte Famillie", message: "Something went wrong. Please try again", onVC: self)
                        Progress.hide(toView: self.view)
                    }
                }
            }).resume()
            
        }
    }

    
    @IBAction func btnNotiifcation(_ sender: Any) {
        let VC = Common.storyboard.instantiateViewController(withIdentifier: "NotificationVC")
        Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
    }
}

extension DashboardController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nameArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newCell", for: indexPath) as! DashBoardCell
        cell.lblName.text = nameArr[indexPath.row]
        if indexPath.row == 0 {
            cell.imgDash.image = UIImage(named:"Le")
        } else if indexPath.row == 9 {
            cell.imgDash.image = UIImage(named:"Activities Extrascolaries")
        } else {
            cell.imgDash.image = UIImage(named:nameArr[indexPath.row])
        }
        cell.contentView.backgroundColor = UIColor.init(hexString: colorCodeArr[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: ((UIScreen.main.bounds.size.width) / 3), height:((UIScreen.main.bounds.size.height)-64) / 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let VC = Common.storyboard.instantiateViewController(withIdentifier: "LeCollegeController")
            Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
        } else if indexPath.row == 1 {
            let VC = Common.storyboard.instantiateViewController(withIdentifier: "AnciensController")
            Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
            
        } else if indexPath.row == 2 {
            
            if let login = UserDefaults.standard.object(forKey: "AlreadyLogin"){
                print(login)
                let flag = UserDefaults.standard.object(forKey: "AlreadyLogin") as! String
                if flag == "P" || flag == "S" || flag == "T"{
                    let VC = Common.storyboard.instantiateViewController(withIdentifier: "LoginDashController")
                    Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
                } else {
                    let VC = Common.storyboard.instantiateViewController(withIdentifier: "LoginController")
                    Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
                }
            } else {
                let VC = Common.storyboard.instantiateViewController(withIdentifier: "LoginController")
                Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
            }

            
            
            
            /*if let login = UserDefaults.standard.object(forKey: "AlreadyLogin"){
                print(login)
                let flag = UserDefaults.standard.object(forKey: "AlreadyLogin") as! String
                if flag == "T" {
                    let VC = Common.storyboard.instantiateViewController(withIdentifier: "LoginDashController")
                    Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
                } else {
                    let VC = Common.storyboard.instantiateViewController(withIdentifier: "LoginController")
                    Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
                }
            } else {
                let VC = Common.storyboard.instantiateViewController(withIdentifier: "LoginController")
                Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
            }*/
        }
            else if indexPath.row == 3 {
            let VC = Common.storyboard.instantiateViewController(withIdentifier: "TransportController")
            Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
        } else if indexPath.row == 5 {
            let VC = Common.storyboard.instantiateViewController(withIdentifier: "CantineController")
            Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
        } else if indexPath.row == 7 {
            let VC = Common.storyboard.instantiateViewController(withIdentifier: "AnnonceVC")
            Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
        } else if indexPath.row == 9 {
            let VC = Common.storyboard.instantiateViewController(withIdentifier: "ActivityController")
            Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
        } else if indexPath.row == 13 {
            let VC = Common.storyboard.instantiateViewController(withIdentifier: "ProductionController")
            Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
        } else if indexPath.row == 11 {
            let VC = Common.storyboard.instantiateViewController(withIdentifier: "NewsController")
            Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
        }
    }
}
