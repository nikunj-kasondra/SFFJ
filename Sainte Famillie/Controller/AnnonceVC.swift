
//
//  NewsController.swift
//  Sainte Famillie
//
//  Created by Rujal on 12/2/17.
//  Copyright © 2017 Nikunj. All rights reserved.
//

import UIKit
import Kingfisher

class AnnonceVC: UIViewController {
    
    @IBOutlet weak var collView: UICollectionView!
    var newsArr = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        collView.register(UINib(nibName: "NewsCell", bundle: nil), forCellWithReuseIdentifier: "newCell")
        callNewsAPI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func callNewsAPI() {
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            let url = URL(string: "http://api.sainte-famille.edu.lb/api/sainteemilie/getannoncesnews?newsId=0")
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                Progress.hide(toView: self.view)
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    do{
                        self.newsArr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSArray
                        DispatchQueue.main.async {
                            self.collView.reloadData()
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
    
    @IBAction func btnVoirClicked(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: "http://www.sainte-famille.edu.lb/Annonces/114/1")!)
    }
    
}

extension AnnonceVC:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.newsArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newCell", for: indexPath) as! NewsCell
        let imageStr = String((self.newsArr.value(forKey: "Thumb") as! NSArray).object(at: indexPath.row) as! String)
        cell.imgNews.kf.setImage(with: URL(string:imageStr!))
        cell.lblNews.text = (self.newsArr.value(forKey: "Title") as! NSArray).object(at: indexPath.row) as? String
        let dateArr = ((self.newsArr.value(forKey: "EntryDate") as! NSArray).object(at: indexPath.row) as? String)?.components(separatedBy: "T")
        let date = dateArr?[0].components(separatedBy: "-")
        cell.lblDate.text = (date?[2])! + "/" + (date?[1])! + "/" + (date?[0])!
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.size.width - 20) / 3, height: 175)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: IndexPath(item: indexPath.row, section: 0)) as! NewsCell
        NewsDetailController.Date = cell.lblDate.text!
        NewsDetailController.Id = ((self.newsArr.value(forKey: "Id") as! NSArray).object(at: indexPath.row) as? NSNumber)!
        NewsDetailController.Header = ((self.newsArr.value(forKey: "Title") as! NSArray).object(at: indexPath.row) as? String)!
        NewsDetailController.Summary = ((self.newsArr.value(forKey: "Summary") as! NSArray).object(at: indexPath.row) as? String)!
        NewsDetailController.Detail = ((self.newsArr.value(forKey: "Details") as! NSArray).object(at: indexPath.row) as? String)!
        AnnoncesDetailVC.imgStr = ((self.newsArr.value(forKey: "Photo") as! NSArray).object(at: indexPath.row) as? String)!
        NewsController.videoId = ((self.newsArr.value(forKey: "VideoURL") as! NSArray).object(at: indexPath.row) as? String)!
        //NewsController.videoId = "https://www.youtube.com/watch?v=kh4VYiW_m50"
        let VC = Common.storyboard.instantiateViewController(withIdentifier: "AnnoncesDetailVC")
        Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
    }
}
