//
//  CarnetsController.swift
//  Sainte Famillie
//
//  Created by Rujal on 12/22/17.
//  Copyright © 2017 Nikunj. All rights reserved.
//

import UIKit
import Alamofire

class CarnetsController: UIViewController {
    
    @IBOutlet weak var traxViewHeight: NSLayoutConstraint!
    @IBOutlet weak var traxView: UIView!
    
    @IBOutlet weak var ageListSpinner: LBZSpinner!
    var dropArr = NSArray()
    var classId = String()
    @IBOutlet weak var tblLivre: UITableView!
    var livreArr = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        tblLivre.register(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "newCell")
        tblLivre.separatorStyle = .none
        tblLivre.estimatedRowHeight = 44
        tblLivre.rowHeight = UITableViewAutomaticDimension
        if let login = UserDefaults.standard.object(forKey: "AlreadyLogin"){
            print(login)
            let flag = UserDefaults.standard.object(forKey: "AlreadyLogin") as! String
            if flag == "S" {
                traxView.isHidden = true
                traxViewHeight.constant = 0
                ageListSpinner.isHidden = true
                classId = UserDefaults.standard.value(forKey: "Code") as! String
                //settView.isHidden = false
                //myAcView.isHidden = false
                
            } else if flag == "P" {
                traxView.isHidden = false
                traxViewHeight.constant = 64
                ageListSpinner.isHidden = false
                let retriveArrayData = UserDefaults.standard.object(forKey:  "parentArr") as? NSData
                
                dropArr = (NSKeyedUnarchiver.unarchiveObject(with: retriveArrayData! as Data) as? NSArray)!
                self.ageListSpinner.updateList(dropArr.value(forKey: "FullName") as! [String])
                self.ageListSpinner.delegate = self
                self.ageListSpinner.text = (dropArr.value(forKey: "FullName") as! NSArray).object(at: 0) as! String
                classId = (dropArr.value(forKey: "Username") as! NSArray).object(at: 0) as! String
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
            let url = URL(string: "http://api.sainte-famille.edu.lb/api/login/getcarnets?userName=\(classId)")
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


extension CarnetsController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.livreArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newCell") as! ListCell
        cell.lblDesc.text = (livreArr.value(forKey: "filedisplay") as! NSArray).object(at: indexPath.row) as? String
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        downLoadFile(indexPath: indexPath.row)
    }
    func openFile(indexPath: Int) {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let fileStr = ((self.livreArr.value(forKey: "filename") as! NSArray).object(at: indexPath) as! String).replacingOccurrences(of: ".resources", with: "")
        let fileURL = path + "/" + String(fileStr)
        let interactionController = UIDocumentInteractionController(url: URL.init(fileURLWithPath: fileURL))
        interactionController.delegate = self
        interactionController.presentPreview(animated: true)
    }
    func downLoadFile(indexPath: Int) {
        let fileManager = FileManager.default
        var paths: [Any] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory: String = paths[0] as? String ?? ""
        let fileStr = ((self.livreArr.value(forKey: "filename") as! NSArray).object(at: indexPath) as! String).replacingOccurrences(of: ".resources", with: "")
        let fileName = String(fileStr)
        let writablePath: String = URL(fileURLWithPath: documentsDirectory).appendingPathComponent(fileName!).path
        
        
        if fileManager.fileExists(atPath:writablePath) {
            Progress.show(toView: self.view)
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let fileStr = ((self.livreArr.value(forKey: "filename") as! NSArray).object(at: indexPath) as! String).replacingOccurrences(of: ".resources", with: "")
            let fileURL = path + "/" + String(fileStr)
            let interactionController = UIDocumentInteractionController(url: URL.init(fileURLWithPath: fileURL))
            interactionController.delegate = self
            interactionController.presentPreview(animated: true)
        } else {
            Progress.show(toView: self.view)
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileStr = ((self.livreArr.value(forKey: "filename") as! NSArray).object(at: indexPath) as! String).replacingOccurrences(of: ".resources", with: "")
                documentsURL.appendPathComponent("/\(fileStr)")
                return (documentsURL, [.removePreviousFile])
            }
            let fileStr = ((self.livreArr.value(forKey: "filename") as! NSArray).object(at: indexPath) as! String).replacingOccurrences(of: ".resources", with: "")
            var docUrl = String("http://api.sainte-famille.edu.lb/api/fileutils/GetSecureFileDownload?secureName=Carnet&fileName=") + String(fileStr)
            docUrl = docUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            Alamofire.download(docUrl, to: destination).downloadProgress(queue: DispatchQueue.global(qos: .utility)) { (progress) in
                print("Progress: \(progress.fractionCompleted)")
                } .validate().responseData { ( response ) in
                    if response.response?.statusCode == 200 {
                        self.openFile(indexPath: indexPath)
                        
                    } else {
                        Progress.hide(toView: self.view)
                        self.view.makeToast("Resource file is not available")
                    }
            }
            
        }
    }

}

extension CarnetsController: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        Progress.hide(toView: self.view)
        return self
    }
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
        Progress.hide(toView: self.view)
    }
}

extension CarnetsController: LBZSpinnerDelegate {
    func spinnerChoose(_ spinner: LBZSpinner, index: Int, value: String) {
        print("Spinner : \(spinner) : { Index : \(index) - \(value) }")
        classId = (dropArr.value(forKey: "Username") as! NSArray).object(at: index) as! String
        self.callLivreAPI()
    }
}
