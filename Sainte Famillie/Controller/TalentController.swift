//
//  TalentController.swift
//  Sainte Famillie
//
//  Created by Rujal on 12/1/17.
//  Copyright © 2017 Nikunj. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import Toast

class TalentController: UIViewController {

    @IBOutlet weak var TalColl: UICollectionView!
    var talentArr = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        TalColl.register(UINib(nibName: "TalentCell", bundle: nil), forCellWithReuseIdentifier: "newCell")
        callProdAPI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func callProdAPI() {
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            let url = URL(string: "http://api.sainte-famille.edu.lb/api/pagedacceuil/getpalmaresetrevuetalents")
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                Progress.hide(toView: self.view)
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    do{
                        self.talentArr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSArray
                        DispatchQueue.main.async {
                            self.TalColl.reloadData()
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
    func openFile(indexPath: Int) {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let fileURL = path + "/" + String((self.talentArr.value(forKey: "PDFName") as! NSArray).object(at: indexPath) as! String)
        let interactionController = UIDocumentInteractionController(url: URL.init(fileURLWithPath: fileURL))
        interactionController.delegate = self
        interactionController.presentPreview(animated: true)
    }
    func downLoadFile(indexPath: Int) {
        let fileManager = FileManager.default
        var paths: [Any] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory: String = paths[0] as? String ?? ""
        let fileName = String((self.talentArr.value(forKey: "PDFName") as! NSArray).object(at: indexPath) as! String)
        let writablePath: String = URL(fileURLWithPath: documentsDirectory).appendingPathComponent(fileName!).path
        
        
        if fileManager.fileExists(atPath:writablePath) {
            Progress.show(toView: self.view)
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let fileURL = path + "/" + String((self.talentArr.value(forKey: "PDFName") as! NSArray).object(at: indexPath) as! String)
            let interactionController = UIDocumentInteractionController(url: URL.init(fileURLWithPath: fileURL))
            interactionController.delegate = self
            interactionController.presentPreview(animated: true)
        } else {
            Progress.show(toView: self.view)
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                documentsURL.appendPathComponent("/\((self.talentArr.value(forKey: "PDFName") as! NSArray).object(at: indexPath) as! String)")
                return (documentsURL, [.removePreviousFile])
            }
            var docUrl = String("http://sainte-famille.edu.lb/UpFiles/PDFs/") + String((self.talentArr.value(forKey: "PDFName") as! NSArray).object(at: indexPath) as! String)
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

extension TalentController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.talentArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newCell", for: indexPath) as! TalentCell
        let imageStr = String("http://sainte-famille.edu.lb/Upfiles/Photos/Small/") + String((self.talentArr.value(forKey: "Photo") as! NSArray).object(at: indexPath.row) as! String)
        cell.imgTal.kf.setImage(with: URL(string:imageStr))
        cell.lblTal.text = (self.talentArr.value(forKey: "Title") as! NSArray).object(at: indexPath.row) as? String
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.size.width - 20) / 3, height: 160)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        downLoadFile(indexPath: indexPath.row)
    }
}

extension TalentController: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        Progress.hide(toView: self.view)
        return self
    }
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
        Progress.hide(toView: self.view)
    }
}

