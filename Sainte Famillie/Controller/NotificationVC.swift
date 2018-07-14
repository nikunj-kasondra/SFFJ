//
//  NotificationVC.swift
//  Sainte Famillie
//
//  Created by Rujal on 2/28/18.
//  Copyright © 2018 Nikunj. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {

    @IBOutlet weak var tblNotification: UITableView!
    var notificationArr = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        tblNotification.register(UINib(nibName: "NotiificationCell", bundle: nil), forCellReuseIdentifier: "newCell")
        tblNotification.separatorStyle = .none
        tblNotification.estimatedRowHeight = 44
        tblNotification.rowHeight = UITableViewAutomaticDimension
        callNotification()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func callNotification() {
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            let url = URL(string: "http://api.sainte-famille.edu.lb/api/pushnotification/getguestpushmessage")
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                Progress.hide(toView: self.view)
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    do{
                        self.notificationArr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSArray
                        DispatchQueue.main.async {
                            self.tblNotification.reloadData()
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
    
}
extension NotificationVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newCell") as! NotiificationCell
        cell.lbl1.text = "SFFJ"
        let date = ((((self.notificationArr.value(forKey: "MessageDate") as! NSArray).object(at: indexPath.row) as! String).components(separatedBy: "T") as! NSArray).object(at: 0) as! String).components(separatedBy: "-")
        cell.lbl2.text = date[2] + "-" + date[1] + "-" + date[0]
        cell.lbl3.text = (self.notificationArr.value(forKey: "MessageDesc") as! NSArray).object(at: indexPath.row) as! String
        return cell
    }
}
