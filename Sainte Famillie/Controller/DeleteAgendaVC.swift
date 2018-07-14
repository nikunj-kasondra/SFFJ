//
//  DeleteAgendaVC.swift
//  Sainte Famillie
//
//  Created by Rujal on 2/13/18.
//  Copyright © 2018 Nikunj. All rights reserved.
//

import UIKit

class DeleteAgendaVC: UIViewController {
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblSubject: UILabel!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var tblAnnocesList: UITableView!
    var presArr = NSMutableArray()
    var agendaArr = NSMutableArray()
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl1: UILabel!
    var index:Int = 0
    var monthName = ["","January","February","March","April","May","June","July","August","September","October","November","December"]
    var deleteIndex:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        tblAnnocesList.register(UINib(nibName: "AnnounListCell", bundle: nil), forCellReuseIdentifier: "newCell")
        tblAnnocesList.separatorStyle = .none
        tblAnnocesList.estimatedRowHeight = 44
        tblAnnocesList.rowHeight = UITableViewAutomaticDimension
        popupView.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
        popupView.addGestureRecognizer(tapGesture)
        callAnnounce()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tapBlurButton(_ sender: UITapGestureRecognizer) {
        popupView.isHidden = true
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func callAnnounce() {
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            let url = "http://api.sainte-famille.edu.lb/api/login/getteacherannouncements?materialId=\(AddAgendaController.code)"
            let urlStr : String = url.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            let url1 = URL(string:urlStr)
            
            URLSession.shared.dataTask(with: url1!, completionHandler: {
                (data, response, error) in
                self.callAgenda()
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    Progress.hide(toView: self.view)
                    do{
                        let arr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSArray
                        self.presArr = arr.mutableCopy() as! NSMutableArray
                        print(self.presArr)
                        DispatchQueue.main.async {
                            self.tblAnnocesList.reloadData()
                        }
                        print(self.presArr)
                        
                    }catch let error as NSError{
                        print(error)
                        Alert.show("Sainte Famillie", message: "Something went wrong. Please try again", onVC: self)
                        Progress.hide(toView: self.view)
                    }
                }
            }).resume()
            
        }
    }
    func callAgenda() {
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            let url = "http://api.sainte-famille.edu.lb/api/login/getteacheragenda?materialId=\(AddAgendaController.code)"
            let urlStr : String = url.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            let url1 = URL(string:urlStr)
            
            URLSession.shared.dataTask(with: url1!, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    Progress.hide(toView: self.view)
                    do{
                        let arr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSArray
                        self.agendaArr = arr.mutableCopy() as! NSMutableArray
                        print(self.agendaArr)
//                        DispatchQueue.main.async {
//                            self.tblAnnocesList.reloadData()
//                        }
                        print(self.presArr)
                        
                    }catch let error as NSError{
                        print(error)
                        Alert.show("Sainte Famillie", message: "Something went wrong. Please try again", onVC: self)
                        Progress.hide(toView: self.view)
                    }
                }
            }).resume()
            
        }
    }

    func btnEyeClicked(sender:UIButton) {
        popupView.isHidden = false
        if index == 0 {
            lblSubject.text =  (self.presArr.value(forKey: "Subject") as! NSArray).object(at: sender.tag) as? String
            
            lblDetail.text = (self.presArr.value(forKey: "Details") as! NSArray).object(at: sender.tag) as? String
            let dateStr = String(describing: (self.presArr.value(forKey: "rDate") as! NSArray).object(at: sender.tag) as! String)
            let dateArr1 = dateStr.components(separatedBy: "T")
            let tmpStr = dateArr1[0] as! String
            let dateArr = tmpStr.components(separatedBy: "-")
            lblDate.text = String(monthName[Int(dateArr[1])!]) + String(", ") + String(dateArr[2]) + String(" ") +  String(" ") + String(dateArr[0])
        } else {
            lblSubject.text =  (self.agendaArr.value(forKey: "Subject") as! NSArray).object(at: sender.tag) as? String
            
            lblDetail.text = (self.agendaArr.value(forKey: "Details") as! NSArray).object(at: sender.tag) as? String
            let dateStr = String(describing: (self.agendaArr.value(forKey: "rDate") as! NSArray).object(at: sender.tag) as! String)
            let dateArr1 = dateStr.components(separatedBy: "T")
            let tmpStr = dateArr1[0] as! String
            let dateArr = tmpStr.components(separatedBy: "-")
            lblDate.text = String(monthName[Int(dateArr[1])!]) + String(", ") + String(dateArr[2]) + String(" ") +  String(" ") + String(dateArr[0])
        }
        
    }
    func callDeleteAgenda(index:Int,id:Int) {
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            let url = "http://api.sainte-famille.edu.lb/api/login/getdeleteteacheragenda?id=\(id)"
            let urlStr : String = url.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            let url1 = URL(string:urlStr)
            
            URLSession.shared.dataTask(with: url1!, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    Progress.hide(toView: self.view)
                    do{
                        let deleteBool = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! Bool
                        print(self.presArr)
                        if deleteBool {
                            self.agendaArr.removeObject(at:self.deleteIndex)
                            
                        }
                        DispatchQueue.main.async {
                            self.tblAnnocesList.reloadData()
                        }
                        print(self.presArr)
                        
                    }catch let error as NSError{
                        print(error)
                        Alert.show("Sainte Famillie", message: "Something went wrong. Please try again", onVC: self)
                        Progress.hide(toView: self.view)
                    }
                }
            }).resume()
            
        }
    }
    
    func deleteAgenda(sender:UIButton){
        if index == 0 {
            let alertController = UIAlertController(title: "Confirm Delete", message: "Are you sure you want delete this Announcement?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.default) {
                UIAlertAction in
                
            }
            let yesAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
                UIAlertAction in
                self.deleteIndex = sender.tag
                self.callDeleteAnnounce(index: sender.tag,id:((self.presArr.value(forKey: "Id") as! NSArray).object(at: sender.tag) as? Int)!)
            }
            alertController.addAction(yesAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)

        } else {
            let alertController = UIAlertController(title: "Confirm Delete", message: "Are you sure you want delete this Agenda?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.default) {
                UIAlertAction in
                
            }
            let yesAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
                UIAlertAction in
                self.deleteIndex = sender.tag
                self.callDeleteAgenda(index: sender.tag,id:((self.agendaArr.value(forKey: "Id") as! NSArray).object(at: sender.tag) as? Int)!)
            }
            alertController.addAction(yesAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)

        }
    }
    func callDeleteAnnounce(index:Int,id:Int) {
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            let url = "http://api.sainte-famille.edu.lb/api/login/getdeleteteacherannouncements?id=\(id)"
            let urlStr : String = url.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            let url1 = URL(string:urlStr)
            
            URLSession.shared.dataTask(with: url1!, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    Progress.hide(toView: self.view)
                    do{
                        let deleteBool = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! Bool
                        print(self.presArr)
                        if deleteBool {
                            self.presArr.removeObject(at:self.deleteIndex)
                            
                        }
                        DispatchQueue.main.async {
                            self.tblAnnocesList.reloadData()
                        }
                        print(self.presArr)
                        
                    }catch let error as NSError{
                        print(error)
                        Alert.show("Sainte Famillie", message: "Something went wrong. Please try again", onVC: self)
                        Progress.hide(toView: self.view)
                    }
                }
            }).resume()
            
        }
    }

    @IBAction func btnAgenda(_ sender: Any) {
        lbl2.isHidden = false
        lbl1.isHidden = true
        index = 1
        DispatchQueue.main.async {
            self.tblAnnocesList.reloadData()
        }
    }
    @IBAction func btnAnnounces(_ sender: Any) {
        lbl2.isHidden = true
        lbl1.isHidden = false
        index = 0
        DispatchQueue.main.async {
            self.tblAnnocesList.reloadData()
        }
    }
}

extension DeleteAgendaVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if index == 0 {
            return self.presArr.count
        } else {
            return self.agendaArr.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if index == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newCell") as! AnnounListCell
            cell.lblSubject.text = (self.presArr.value(forKey: "Subject") as! NSArray).object(at: indexPath.row) as? String
            cell.btnEye.addTarget(self, action: #selector(btnEyeClicked), for: .touchUpInside)
            cell.btnEye.tag = indexPath.row
            cell.lblDetail.text =  (self.presArr.value(forKey: "Details") as! NSArray).object(at: indexPath.row) as? String
            let dateStr = String(describing: (self.presArr.value(forKey: "rDate") as! NSArray).object(at: indexPath.row) as! String)
            let dateArr1 = dateStr.components(separatedBy: "T")
            let tmpStr = dateArr1[0] as! String
            let dateArr = tmpStr.components(separatedBy: "-")
            cell.lblDate.text = String(monthName[Int(dateArr[1])!]) + String(", ") + String(dateArr[2]) + String(" ") +  String(" ") + String(dateArr[0])
            cell.btnDelete.addTarget(self, action: #selector(deleteAgenda), for: .touchUpInside)
            cell.btnDelete.tag = indexPath.row
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newCell") as! AnnounListCell
            cell.lblSubject.text = (self.agendaArr.value(forKey: "Subject") as! NSArray).object(at: indexPath.row) as? String
            cell.btnEye.addTarget(self, action: #selector(btnEyeClicked), for: .touchUpInside)
            cell.btnEye.tag = indexPath.row
            cell.lblDetail.text =  (self.agendaArr.value(forKey: "Details") as! NSArray).object(at: indexPath.row) as? String
            let dateStr = String(describing: (self.agendaArr.value(forKey: "rDate") as! NSArray).object(at: indexPath.row) as! String)
            let dateArr1 = dateStr.components(separatedBy: "T")
            let tmpStr = dateArr1[0] as! String
            let dateArr = tmpStr.components(separatedBy: "-")
            cell.lblDate.text = String(monthName[Int(dateArr[1])!]) + String(", ") + String(dateArr[2]) + String(" ") +  String(" ") + String(dateArr[0])
            cell.btnDelete.addTarget(self, action: #selector(deleteAgenda), for: .touchUpInside)
            cell.btnDelete.tag = indexPath.row
            return cell

        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
