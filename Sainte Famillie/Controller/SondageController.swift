//
//  SondageController.swift
//  Sainte Famillie
//
//  Created by Rujal on 3/18/18.
//  Copyright © 2018 Nikunj. All rights reserved.
//

import UIKit
import Alamofire

class SondageController: UIViewController {
    
    
    @IBOutlet weak var tblPopup: UITableView!
    @IBOutlet weak var tblPopHeight: NSLayoutConstraint!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var tblANs: UITableView!
    @IBOutlet weak var lblQue: UILabel!
    var resArr = NSArray()
    var ansArr = NSArray()
    var resultArr = NSArray()
    var queId: NSNumber = 0
    var ansId: NSNumber = 0
    var roleName: String = ""
    var tblArr = NSMutableArray()
    var totalNoAns:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tblANs.register(UINib(nibName: "AnswerCell", bundle: nil), forCellReuseIdentifier: "newCell")
        tblANs.separatorStyle = .none
        tblPopup.register(UINib(nibName: "PopupCell", bundle: nil), forCellReuseIdentifier: "newCell1")
        tblPopup.separatorStyle = .none
        popupView.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
        popupView.addGestureRecognizer(tapGesture)
        let flag = UserDefaults.standard.object(forKey: "AlreadyLogin") as! String
        if flag == "S" {
            roleName = "student"
        } else if flag == "P" {
            roleName = "parent"
        } else if flag == "T" {
            roleName = "teacher"
        }
        callQue()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tapBlurButton(_ sender: UITapGestureRecognizer) {
        popupView.isHidden = true
    }

    func callQue() {
        
            if !Reachability.isConnectedToNetwork() {
                Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
            } else {
                Progress.show(toView: self.view)
                let url = URL(string: "http://api.sainte-famille.edu.lb/api/login/getpollquestions?roleName=\(roleName)")
                URLSession.shared.dataTask(with: url!, completionHandler: {
                    (data, response, error) in
                    if(error != nil){
                        Progress.hide(toView: self.view)
                        print("error")
                    }else{
                        do{
                            self.resArr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSArray
                            if self.resArr.count != 0 {
                                let dict = self.resArr.object(at: 0) as! NSDictionary
                                self.totalNoAns = dict.value(forKey: "TotalAns") as! Int
                                DispatchQueue.main.async{
                                    if let name = dict.value(forKey: "Text") as? String {
                                        self.lblQue.text = dict.value(forKey: "Text") as! String
                                        self.queId = dict.value(forKey: "Id") as! NSNumber
                                        self.callAnswer()
                                    } else {
                                        self.queId = dict.value(forKey: "Id") as! NSNumber
                                        self.callResultant()
                                    }
                                }
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
    
    func callAnswer() {
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            let url = URL(string: "http://api.sainte-famille.edu.lb/api/login/getpollanswer?qId=\(queId)")
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    do{
                        self.ansArr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSArray
                        self.tblArr.removeAllObjects()
                        for i in 0..<self.ansArr.count {
                            self.tblArr.add(0)
                        }
                        DispatchQueue.main.async {
                            self.tblANs.reloadData()
                        }
                        Progress.hide(toView: self.view)
                    }catch let error as NSError{
                        print(error)
                        Alert.show("Sainte Famillie", message: "Something went wrong. Please try again", onVC: self)
                        Progress.hide(toView: self.view)
                    }
                }
            }).resume()
            
        }
    }
    
    @IBAction func btnBackClcked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    @IBAction func btnVoter(_ sender: Any) {
        if ansId == 0 {
            Alert.show("SFFJ", message: "Please select atleast one answer", onVC: self)
        } else {
            
            let headers: HTTPHeaders = ["Accept": "application/json", "Content-Type" :"application/json"]
            let dict = ["qId":queId,"AnsId":ansId,"username":UserDefaults.standard.object(forKey: "Code") as! String] as [String : Any]
            Progress.show(toView: self.view)
            Alamofire.request("http://api.sainte-famille.edu.lb/api/login/postpollvote?qId=\(queId)&AnsId=\(ansId)&username=\(UserDefaults.standard.object(forKey: "Code") as! String)", method: .post, parameters: dict, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                
                // original URL request
                print("Request is :",response.request!)
                
                // HTTP URL response --> header and status code
                print("Response received is :",response.response!)
                
                // server data : example 267 bytes
                print("Response data is :",response.data!)
                Progress.hide(toView: self.view)
                self.callResultant()
//                do {
//                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! NSDictionary
//                    if json.value(forKey: "success") as! String == "1" {
//                        let alertView = UIAlertController(title: "Sainte Famillie", message: "Email sent successfully. Info@sainte-famille.edu.lb", preferredStyle: .alert)
//                        let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
//                            self.navigationController?.popViewController(animated: true)
//                        })
//                        alertView.addAction(action)
//                        self.present(alertView, animated: true, completion: nil)
//                    } else {
//                        Alert.show("Sainte Famillie", message: "Something went wrong. Please try again", onVC: self)
//                    }
//                } catch _ {
//                    Alert.show("Sainte Famillie", message: "Something went wrong. Please try again", onVC: self)
//                }
                
                // result of response serialization : SUCCESS / FAILURE
                print("Response result is :",response.result)
                
                debugPrint("Debug Print :", response)
            }
        }
    }
    
    
    @IBAction func btnResultant(_ sender: Any) {
        callResultant()
    }
    
    func callResultant() {
        popupView.isHidden = false
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            let url = URL(string: "http://api.sainte-famille.edu.lb/api/login/getpollresults?qId=\(queId)&roleName=\(roleName)")
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    do{
                        self.resultArr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSArray
                        DispatchQueue.main.async {
                            self.tblPopup.reloadData()
                        }
                        Progress.hide(toView: self.view)
                    }catch let error as NSError{
                        print(error)
                        Alert.show("Sainte Famillie", message: "Something went wrong. Please try again", onVC: self)
                        Progress.hide(toView: self.view)
                    }
                }
            }).resume()
            
        }
    }
    func btnClicked(btn:UIButton) {
        tblArr.removeAllObjects()
        for i in 0..<self.ansArr.count {
            if i == btn.tag {
                ansId = (self.ansArr.value(forKey: "Id") as! NSArray).object(at: btn.tag) as! NSNumber
                tblArr.add(1)
            } else {
                tblArr.add(0)
            }
        }
        DispatchQueue.main.async {
            self.tblANs.reloadData()
        }
    }
}

extension SondageController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tblANs == tableView {
            tblHeight.constant = CGFloat(ansArr.count * 44)
            return ansArr.count
        } else {
            tblPopHeight.constant = CGFloat(resultArr.count * 44)
            return resultArr.count
        }
        
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblANs {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newCell") as! AnswerCell
            if tblArr.object(at: indexPath.row) as! Int == 0 {
                cell.img.image = UIImage(named:"Off")
            } else {
                cell.img.image = UIImage(named:"On")
            }
            cell.lblAns.text = (self.ansArr.value(forKey: "Answer") as! NSArray).object(at: indexPath.row) as! String
            cell.btnCheckMark.tag = indexPath.row
            cell.btnCheckMark.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newCell1") as! PopupCell
            let per = Double(100 * ((self.resultArr.value(forKey: "AnsCount") as! NSArray).object(at: indexPath.row) as! Int) * 10) / Double(totalNoAns * self.resultArr.count)
            cell.lblAns.text = String((self.resultArr.value(forKey: "Answer") as! NSArray).object(at: indexPath.row) as! String) + String(format:" (%.2f", per) + String("%)")
            return cell
        }

    }
}
