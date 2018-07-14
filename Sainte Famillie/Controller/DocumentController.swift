//
//  DocumentController.swift
//  Sainte Famillie
//
//  Created by Rujal on 12/21/17.
//  Copyright © 2017 Nikunj. All rights reserved.
//

import UIKit

class DocumentController: UIViewController {
    
    @IBOutlet weak var lblSup: UILabel!
    @IBOutlet weak var lblTrax: UILabel!
    @IBOutlet weak var traxViewHeight: NSLayoutConstraint!
    @IBOutlet weak var traxView: UIView!
    @IBOutlet weak var ageListSpinner: LBZSpinner!
    @IBOutlet weak var tblLivre: UITableView!
    var dropArr = NSArray()
    var classId = String()
    var livreArr = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        tblLivre.register(UINib(nibName: "LivreCell", bundle: nil), forCellReuseIdentifier: "newCell")
        tblLivre.separatorStyle = .none
        tblLivre.estimatedRowHeight = 44
        tblLivre.rowHeight = UITableViewAutomaticDimension
        if let login = UserDefaults.standard.object(forKey: "AlreadyLogin"){
            print(login)
            let flag = UserDefaults.standard.object(forKey: "AlreadyLogin") as! String
            if flag == "S" {
                ageListSpinner.isHidden = true
                classId = UserDefaults.standard.value(forKey: "role") as! String
                traxView.isHidden = true
                traxViewHeight.constant = 0
                //settView.isHidden = false
                //myAcView.isHidden = false
                
            } else if flag == "P" {
                ageListSpinner.isHidden = false
                traxViewHeight.constant = 64
                traxView.isHidden = false
                lblTrax.text = ""
                lblSup.text = ""
                let retriveArrayData = UserDefaults.standard.object(forKey:  "parentArr") as? NSData
                
                dropArr = (NSKeyedUnarchiver.unarchiveObject(with: retriveArrayData! as Data) as? NSArray)!
                self.ageListSpinner.updateList(dropArr.value(forKey: "FullName") as! [String])
                self.ageListSpinner.delegate = self
                self.ageListSpinner.text = (dropArr.value(forKey: "FullName") as! NSArray).object(at: 0) as! String
                classId = (dropArr.value(forKey: "ClassId") as! NSArray).object(at: 0) as! String
            }  else {
                traxView.isHidden = true
                traxViewHeight.constant = 0
            }
        }
        callLivreAPI()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func callLivreAPI() {
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            let url = URL(string: "http://api.sainte-famille.edu.lb/api/login/getdocuments?classId=\(classId)")
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    do{
                        Progress.hide(toView: self.view)
                        self.livreArr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSArray
                        
                    }
                    catch let error as NSError{
                        print(error)
                        Alert.show("Sainte Famillie", message: "Something went wrong. Please try again", onVC: self)
                        Progress.hide(toView: self.view)
                    }
                    DispatchQueue.main.async {
                        self.tblLivre.reloadData()
                    }
                }
            }).resume()
            
        }
    }

}


extension DocumentController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.livreArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newCell") as! LivreCell
        cell.lblLibre.text = (self.livreArr.value(forKey: "Title") as! NSArray).object(at: indexPath.row) as? String
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DocumentDetailController.Id = ((self.livreArr.value(forKey: "Code") as! NSArray).object(at: indexPath.row) as? String)!
        let VC = Common.storyboard.instantiateViewController(withIdentifier: "DocumentDetailController")
        Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
    }
}
extension DocumentController: LBZSpinnerDelegate {
    func spinnerChoose(_ spinner: LBZSpinner, index: Int, value: String) {
        print("Spinner : \(spinner) : { Index : \(index) - \(value) }")
        classId = (dropArr.value(forKey: "ClassId") as! NSArray).object(at: index) as! String
        self.callLivreAPI()
    }
}
