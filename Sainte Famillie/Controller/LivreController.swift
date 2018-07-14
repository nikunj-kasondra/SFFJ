//
//  LivreController.swift
//  Sainte Famillie
//
//  Created by Rujal on 11/28/17.
//  Copyright © 2017 Nikunj. All rights reserved.
//

import UIKit

class LivreController: UIViewController {

    @IBOutlet weak var tblLivre: UITableView!
    var livreArr = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        tblLivre.register(UINib(nibName: "LivreCell", bundle: nil), forCellReuseIdentifier: "newCell")
        tblLivre.separatorStyle = .none
        tblLivre.estimatedRowHeight = 44
        tblLivre.rowHeight = UITableViewAutomaticDimension
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
            let url = URL(string: "http://api.sainte-famille.edu.lb/api/pagedacceuil/getproductionslivredor")
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


extension LivreController: UITableViewDelegate,UITableViewDataSource {
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
        LivreDetailsController.header = ((self.livreArr.value(forKey: "Title") as! NSArray).object(at: indexPath.row) as? String)!
        LivreDetailsController.details = ((self.livreArr.value(forKey: "Details") as! NSArray).object(at: indexPath.row) as? String)!
        let VC = Common.storyboard.instantiateViewController(withIdentifier: "LivreDetailsController")
        Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
    }
}
