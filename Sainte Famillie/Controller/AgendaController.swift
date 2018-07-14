//
//  AgendaController.swift
//  Sainte Famillie
//
//  Created by Rujal on 1/5/18.
//  Copyright © 2018 Nikunj. All rights reserved.
//

import UIKit

class AgendaController: UIViewController {

    @IBOutlet weak var tblAgenda: UITableView!
    @IBOutlet weak var ageListSpinner: LBZSpinner!
    @IBOutlet weak var lblDet: UILabel!
    @IBOutlet weak var lblDat: UILabel!
    @IBOutlet weak var lblSubject: UILabel!
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var lblDate: UILabel!
    var dateStr = String()
    var livreArr = NSArray()
    var dropArr = NSArray()
    var classId = String()
    var monthName = ["","January","February","March","April","May","June","July","August","September","October","November","December"]
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        lblDate.text = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateStr = dateFormatter.string(from: date)
        tblAgenda.register(UINib(nibName: "AgendaCell", bundle: nil), forCellReuseIdentifier: "newCell")
        tblAgenda.separatorStyle = .none
        tblAgenda.estimatedRowHeight = 44
        tblAgenda.rowHeight = UITableViewAutomaticDimension
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
        popView.addGestureRecognizer(tapGesture)
        if let login = UserDefaults.standard.object(forKey: "AlreadyLogin"){
            print(login)
            let flag = UserDefaults.standard.object(forKey: "AlreadyLogin") as! String
            if flag == "S" {
                ageListSpinner.isHidden = true
                classId = UserDefaults.standard.value(forKey: "role") as! String
                //settView.isHidden = false
                //myAcView.isHidden = false
                
            } else if flag == "P" {
                ageListSpinner.isHidden = false
                let retriveArrayData = UserDefaults.standard.object(forKey:  "parentArr") as? NSData
                
                dropArr = (NSKeyedUnarchiver.unarchiveObject(with: retriveArrayData! as Data) as? NSArray)!
                self.ageListSpinner.updateList(dropArr.value(forKey: "FullName") as! [String])
                self.ageListSpinner.delegate = self
                self.ageListSpinner.text = (dropArr.value(forKey: "FullName") as! NSArray).object(at: 0) as! String
                classId = (dropArr.value(forKey: "ClassId") as! NSArray).object(at: 0) as! String
            }
        }
            callLivreAPI()
        // Do any additional setup after loading the view.
    }
    func tapBlurButton(_ sender: UITapGestureRecognizer) {
        popView.isHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        popView.isHidden = true
    }
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func callLivreAPI() {
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            let url = URL(string: "http://api.sainte-famille.edu.lb/api/login/getagendaaccess?classId=\(classId)&agendaDate=\(dateStr)")
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    do{
                        Progress.hide(toView: self.view)
                        self.livreArr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSArray
                        if self.livreArr.count != 0 {
                            
                            DispatchQueue.main.async {
                                self.tblAgenda.reloadData()
                            }
                            
                        } else {
                            DispatchQueue.main.async {
                                self.tblAgenda.reloadData()
                            }
                            
                        }
                        
                    }
                    catch let error as NSError{
                        print(error)
                        Alert.show("Sainte Famillie", message: "Something went wrong. Please try again", onVC: self)
                        Progress.hide(toView: self.view)
                    }
                    
                }
            }).resume()
            
        }
    }

    @IBAction func btnEyeClicked(_ sender: Any) {
        popView.isHidden = false
        let dict = self.livreArr.object(at:(sender as AnyObject).tag) as! NSDictionary
        lblSubject.text = dict.value(forKey:"Subject") as? String
        lblDet.text = dict.value(forKey:"Details") as? String
        let dateStr = ((dict.value(forKey:"rDate") as! String).components(separatedBy: "T") as! NSArray).object(at: 0) as! String
        let dateArr = dateStr.components(separatedBy: "-")
        lblDat.text = String(monthName[Int(dateArr[1])!]) + String(", ") + String(dateArr[2]) + String(" ") +  String(" ") + String(dateArr[0])
    }
    @IBAction func btnDateClicked(_ sender: Any) {
        DatePickerDialog().show("Sainte Famillie", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                self.lblDate.text = formatter.string(from: dt)
                formatter.dateFormat = "yyyy-MM-dd"
                self.dateStr = formatter.string(from: date!)
                self.callLivreAPI()
            }
        }
    }
}

extension AgendaController: LBZSpinnerDelegate {
    func spinnerChoose(_ spinner: LBZSpinner, index: Int, value: String) {
        print("Spinner : \(spinner) : { Index : \(index) - \(value) }")
        classId = (dropArr.value(forKey: "ClassId") as! NSArray).object(at: index) as! String
        self.callLivreAPI()
    }
}
extension AgendaController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.livreArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newCell") as! AgendaCell
        let dict = self.livreArr.object(at:indexPath.row) as! NSDictionary
        cell.lblSubject.text = String(dict.value(forKey:"Code") as! String)
        //cell.lblSubject.text = String(dict.value(forKey:"Code") as! String) + String(" : ") + String(dict.value(forKey:"Subject") as! String)
        cell.btnEye.addTarget(self, action: #selector(btnEyeClicked), for: .touchUpInside)
        cell.btnEye.tag = indexPath.row
        cell.lblDetail.text =  dict.value(forKey:"Details") as? String
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

