//
//  AgendaListController.swift
//  Sainte Famillie
//
//  Created by Rujal on 1/21/18.
//  Copyright © 2018 Nikunj. All rights reserved.
//

import UIKit

class AgendaListController: UIViewController {
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblSubject: UILabel!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var tblAnnocesList: UITableView!
    var presArr = NSMutableArray()
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
        callEnvoyer()
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
    func callEnvoyer() {
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            let url = "http://api.sainte-famille.edu.lb/api/login/getteacheragenda?materialId=\(MatricesController.serCode)"
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
                        let delete = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! Bool
                        if delete {
                            self.presArr.removeObject(at: self.deleteIndex)
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

    
    func btnEyeClicked(sender:UIButton) {
        popupView.isHidden = false
        lblSubject.text = (self.presArr.value(forKey: "Subject") as! NSArray).object(at: sender.tag) as? String
        
        lblDetail.text = (self.presArr.value(forKey: "Details") as! NSArray).object(at: sender.tag) as? String
        let dateStr = String(describing: (self.presArr.value(forKey: "rDate") as! NSArray).object(at: sender.tag) as! String)
        let dateArr1 = dateStr.components(separatedBy: "T")
        let tmpStr = dateArr1[0] as! String
        let dateArr = tmpStr.components(separatedBy: "-")
        lblDate.text = String(monthName[Int(dateArr[1])!]) + String(", ") + String(dateArr[2]) + String(" ") +  String(" ") + String(dateArr[0])
    }
    func deleteAgenda(sender:UIButton){
        let alertController = UIAlertController(title: "Confirm Delete", message: "Are you sure you want delete this Agenda?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
        }
        let yesAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.deleteIndex = sender.tag
            self.callDeleteAgenda(index: sender.tag,id:((self.presArr.value(forKey: "Id") as! NSArray).object(at: sender.tag) as? Int)!)
        }
        alertController.addAction(yesAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension AgendaListController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}


