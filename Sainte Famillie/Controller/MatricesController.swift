//
//  MatricesController.swift
//  Sainte Famillie
//
//  Created by Rujal on 1/19/18.
//  Copyright © 2018 Nikunj. All rights reserved.
//

import UIKit

class MatricesController: UIViewController {

    @IBOutlet weak var tblMatrices: UITableView!
    var presArr = NSArray()
    static var resArr = NSArray()
    static var serCode = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        tblMatrices.register(UINib(nibName: "MatricesCell", bundle: nil), forCellReuseIdentifier: "newCell")
        tblMatrices.separatorStyle = .none
        tblMatrices.estimatedRowHeight = 44
        tblMatrices.rowHeight = UITableViewAutomaticDimension
        callGetClassId()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func callGetClassId() {
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            let url = URL(string: "http://api.sainte-famille.edu.lb/api/login/getteacherclassid?userName=\(UserDefaults.standard.value(forKey: "Code")as! String)")
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    Progress.hide(toView: self.view)
                    do{
                        self.presArr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSArray
                        MatricesController.resArr = self.presArr
                        DispatchQueue.main.async {
                            self.tblMatrices.reloadData()
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
    func addAnnouncement(sender:UIButton) {
        print(presArr)
        AddAnnoController.id = String(describing: (self.presArr.value(forKey: "Title") as! NSArray).object(at: sender.tag) as! String)
        AddAnnoController.code = String(describing: (self.presArr.value(forKey: "CourseCat") as! NSArray).object(at: sender.tag) as! String) + String(describing: (self.presArr.value(forKey: "ClassId") as! NSArray).object(at: sender.tag) as! String)
        MatricesController.serCode = String(describing: (self.presArr.value(forKey: "Code") as! NSArray).object(at: sender.tag) as! String)
        let VC = Common.storyboard.instantiateViewController(withIdentifier: "AddAnnoController")
        Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
        
    }
    func addAgenda(sender:UIButton) {
        AddAgendaController.id = String(describing: (self.presArr.value(forKey: "Title") as! NSArray).object(at: sender.tag) as! String)
        AddAgendaController.code = String(describing: (self.presArr.value(forKey: "CourseCat") as! NSArray).object(at: sender.tag) as! String) + String(describing: (self.presArr.value(forKey: "ClassId") as! NSArray).object(at: sender.tag) as! String)
         MatricesController.serCode = String(describing: (self.presArr.value(forKey: "Code") as! NSArray).object(at: sender.tag) as! String)
        AddAgendaController.code = String(describing: (self.presArr.value(forKey: "Code") as! NSArray).object(at: sender.tag) as! String)
        let VC = Common.storyboard.instantiateViewController(withIdentifier: "AddAgendaController")
        Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
        
    }
    func deleteAgenda(sender:UIButton) {
        AddAgendaController.code = String(describing: (self.presArr.value(forKey: "Code") as! NSArray).object(at: sender.tag) as! String) 
        let VC = Common.storyboard.instantiateViewController(withIdentifier: "DeleteAgendaVC")
        Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
    }
}

extension MatricesController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newCell") as! MatricesCell
        cell.lblName.text = String(describing: (self.presArr.value(forKey: "Title") as! NSArray).object(at: indexPath.row) as! String)
        cell.btnAnnouncement.tag = indexPath.row
        cell.btnAgenda.tag = indexPath.row
        cell.btnAnnouncement.addTarget(self, action: #selector(addAnnouncement), for: .touchUpInside)
        cell.btnAgenda.addTarget(self, action: #selector(addAgenda), for: .touchUpInside)
        cell.btnDelete.addTarget(self, action: #selector(deleteAgenda), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

