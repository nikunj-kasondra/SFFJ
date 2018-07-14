//
//  DocumentDetailController.swift
//  Sainte Famillie
//
//  Created by Rujal on 12/21/17.
//  Copyright © 2017 Nikunj. All rights reserved.
//

import UIKit
import Alamofire

class DocumentDetailController: UIViewController {

    @IBOutlet weak var tblDoc: UITableView!
   
    @IBOutlet weak var lblNoData: UILabel!
    static var Id = String()
    var livreArr = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        tblDoc.register(UINib(nibName: "FishesCell", bundle: nil), forCellReuseIdentifier: "newCell")
        tblDoc.separatorStyle = .none
        tblDoc.estimatedRowHeight = 44
        tblDoc.rowHeight = UITableViewAutomaticDimension
        lblNoData.isHidden = true
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
            

            let url = URL(string: "http://api.sainte-famille.edu.lb/api/login/getdocumentsdetails?materialId=\(DocumentDetailController.Id)")
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    do{
                        Progress.hide(toView: self.view)
                        self.livreArr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSArray
                        if self.livreArr.count == 0 {
                            DispatchQueue.main.async {
                            self.lblNoData.isHidden = false
                            }
                        }
                        DispatchQueue.main.async {
                            self.tblDoc.reloadData()
                        }
                        print(self.livreArr)
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
    func openFile(indexPath: Int) {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let fileStr = ((self.livreArr.value(forKey: "details") as! NSArray).object(at: indexPath) as! String).replacingOccurrences(of: ".resources", with: "")
        let fileURL = path + "/" + String(fileStr)
        let interactionController = UIDocumentInteractionController(url: URL.init(fileURLWithPath: fileURL))
        interactionController.delegate = self
        interactionController.presentPreview(animated: true)
    }
    func downLoadFile(indexPath: Int) {
        let fileManager = FileManager.default
        var paths: [Any] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory: String = paths[0] as? String ?? ""
        let fileStr = ((self.livreArr.value(forKey: "details") as! NSArray).object(at: indexPath) as! String).replacingOccurrences(of: ".resources", with: "")
        let fileName = String(fileStr)
        let writablePath: String = URL(fileURLWithPath: documentsDirectory).appendingPathComponent(fileName!).path
        
        
        if fileManager.fileExists(atPath:writablePath) {
            Progress.show(toView: self.view)
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let fileStr = ((self.livreArr.value(forKey: "details") as! NSArray).object(at: indexPath) as! String).replacingOccurrences(of: ".resources", with: "")
            let fileURL = path + "/" + String(fileStr)
            let interactionController = UIDocumentInteractionController(url: URL.init(fileURLWithPath: fileURL))
            interactionController.delegate = self
            interactionController.presentPreview(animated: true)
        } else {
            Progress.show(toView: self.view)
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileStr = ((self.livreArr.value(forKey: "details") as! NSArray).object(at: indexPath) as! String).replacingOccurrences(of: ".resources", with: "")
                documentsURL.appendPathComponent("/\(fileStr)")
                return (documentsURL, [.removePreviousFile])
            }
            var fileStr = ((self.livreArr.value(forKey: "details") as! NSArray).object(at: indexPath) as! String).replacingOccurrences(of: ".resources", with: "")
            var docUrl = String("http://api.sainte-famille.edu.lb/api/fileutils/GetSecureFileDownload?secureName=Document&fileName=") + String(fileStr.replacingOccurrences(of: " ", with: "%20"))
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

extension DocumentDetailController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.livreArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newCell") as! FishesCell
        cell.lblDesc.text = (livreArr.value(forKey: "details") as! NSArray).object(at: indexPath.row) as? String
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        downLoadFile(indexPath: indexPath.row)
    }
}
extension DocumentDetailController: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        Progress.hide(toView: self.view)
        return self
    }
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
        Progress.hide(toView: self.view)
    }
}

