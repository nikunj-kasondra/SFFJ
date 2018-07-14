//
//  NewsDetailController.swift
//  Sainte Famillie
//
//  Created by Rujal on 12/2/17.
//  Copyright © 2017 Nikunj. All rights reserved.
//

import UIKit
import Kingfisher
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

class NewsDetailController: UIViewController,UIPageViewControllerDataSource {
    fileprivate var pageViewController: UIPageViewController?
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    var imgIndex:Int = 0
    @IBOutlet weak var pageView: UIView!
    @IBOutlet weak var imgAuth: UIImageView!
    @IBOutlet weak var lblHtml: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    var sectionName = String()
    var htmlStr = String()
    var prodArr = NSArray()
    static var Id = NSNumber()
    static var Header = String()
    static var Summary = String()
    static var Detail = String()
    static var Date = String()
    static var link = String()
    static var finalCount:Int = 0
    var imageArr = NSMutableArray()
    fileprivate var contentImages = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attrStr1 = try! NSAttributedString(
            data: NewsDetailController.Header.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        lblHeader.attributedText = attrStr1
        let attrStr2 = try! NSAttributedString(
            data: NewsDetailController.Detail.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        lblDetail.attributedText = attrStr2
        lblDate.text = NewsDetailController.Date
        let attrStr = try! NSAttributedString(
            data: NewsDetailController.Summary.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        self.lblHtml.attributedText = attrStr
        let notificationName = Notification.Name("NotificationIdentifier")
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(imageClicked), name: notificationName, object: nil)
        callProdAPI()
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
    func imageClicked() {
        print(imgIndex)
        NewsImageController.imgStr = imageArr.object(at:imgIndex) as! String
        if NewsController.videoId != "" {
            if imgIndex < imageArr.count - 1 {
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "NewsImageController")
                self.navigationController?.pushViewController(VC!, animated: true)
            } else {
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "YoutubeVC")
                self.navigationController?.pushViewController(VC!, animated: false)
            }
        } else {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "NewsImageController")
            self.navigationController?.pushViewController(VC!, animated: true)
        }
        
    }
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func callProdAPI() {
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            let url = URL(string: "http://api.sainte-famille.edu.lb/api/pagedacceuil/getnouvellesducollegenewsphotogallerybyid?newsId=\(NewsDetailController.Id)")
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    do{
                        self.prodArr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSArray
                        var imageURL = String()
                        self.imageArr.removeAllObjects()
                        if self.prodArr.count != 0 {
                            for i in 0..<self.prodArr.count {
                                let dict = self.prodArr.object(at: i) as! NSDictionary
                                if dict.value(forKey: "Photo") as? String != nil {
                                    imageURL = dict.value(forKey: "Photo") as! String
                                    self.contentImages.append(imageURL)
                                    self.imageArr.add(imageURL)
                                }
                                
                            }
                            if NewsController.videoId != "" {
                                self.contentImages.append(NewsController.videoId)
                                self.imageArr.add(NewsController.videoId)
                            }
                            DispatchQueue.main.async {
                                self.createPageViewController()
                                self.setupPageControl()
                                //                                imageURL = String("http://sainte-famille.edu.lb/Upfiles/Photos/Large/") + String(imageURL)
                                //
                                //                                self.imgAuth.kf.setImage(with: URL(string:imageURL))
                                Progress.hide(toView: self.view)
                            }
                            
                        } else {
                            if NewsController.videoId != "" {
                                self.contentImages.append(NewsController.videoId)
                                self.imageArr.add(NewsController.videoId)
                            }
                            DispatchQueue.main.async {
                                self.createPageViewController()
                                self.setupPageControl()
                                //                                imageURL = String("http://sainte-famille.edu.lb/Upfiles/Photos/Large/") + String(imageURL)
                                //
                                //                                self.imgAuth.kf.setImage(with: URL(string:imageURL))
                                
                            }
                            Progress.hide(toView: self.view)
                        }
                        NewsDetailController.finalCount = self.imageArr.count
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
    
    fileprivate func createPageViewController() {
        
        let pageController = self.storyboard!.instantiateViewController(withIdentifier: "PageController") as! UIPageViewController
        pageController.dataSource = self
        if contentImages.count > 0 {
            let firstController = getItemController(0)!
            let startingViewControllers = [firstController]
            pageController.setViewControllers(startingViewControllers, direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        }
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        pageViewController?.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 270)
        self.pageView.addSubview(pageViewController!.view)
        pageViewController!.didMove(toParentViewController: self)
    }
    
    fileprivate func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.gray
        appearance.currentPageIndicatorTintColor = UIColor.darkText
        appearance.backgroundColor = UIColor.darkGray
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageItemController
        imgIndex = itemController.itemIndex
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex-1)
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageItemController
        imgIndex = itemController.itemIndex
        if itemController.itemIndex+1 < contentImages.count {
            return getItemController(itemController.itemIndex+1)
        }
        
        return nil
    }
    
    fileprivate func getItemController(_ itemIndex: Int) -> PageItemController? {
        
        if itemIndex < contentImages.count {
            let pageItemController = self.storyboard!.instantiateViewController(withIdentifier: "ItemController") as! PageItemController
            pageItemController.itemIndex = itemIndex
            pageItemController.imageName = contentImages[itemIndex]
            return pageItemController
        }
        
        return nil
    }
    
    // MARK: - Page Indicator
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return contentImages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    // MARK: - Additions
    
    func currentControllerIndex() -> Int {
        
        let pageItemController = self.currentController()
        
        if let controller = pageItemController as? PageItemController {
            return controller.itemIndex
        }
        
        return -1
    }
    
    func currentController() -> UIViewController? {
        
        if self.pageViewController?.viewControllers?.count > 0 {
            return self.pageViewController?.viewControllers![0]
        }
        
        return nil
    }
    
}
