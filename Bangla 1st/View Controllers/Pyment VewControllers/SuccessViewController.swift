//
//  SuccessViewController.swift
//  Paymentgateway
//
//  Created by Saravana Kumar Annadurai on 07/01/16.
//  Copyright (c) 2016 Saravana Kumar Annadurai. All rights reserved.
//

import UIKit

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



class SuccessViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tblSuccess: UITableView!
   
    var jsondict = NSDictionary()
    
    var arrFieldNameKeysSorted : [Any] = []
    
    
    var keyValuePairArr:[Dictionary<String, AnyObject>] = []
    
    var arrFieldNames = ["Account Id","Amount","Billing Address" ,"Billing City","Billing Country","Billing Name" ,"Billing Phone","Billing PostalCode", "Billing State", "Billing Email" , "Date Created", "Delivery Address", "Delivery City", "Delivery Country", "Delivery Name", "Delivery Phone", "Delivery PostalCode", "Delivery State", "Description", "IsFlagged", "Merchant Ref. No.", "Mode", "Payment Id", "Payment Mode", "Payment Status", "Response Message", "Secure Hash", "Transaction Id"]
    
    
    var error: NSError?
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

       // jsondict = NSMutableDictionary()

        NotificationCenter.default.addObserver(self, selector: #selector(SuccessViewController.ResponseNew(_:)), name: NSNotification.Name(rawValue: "JSON_NEW"), object: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "JSON_DICT"), object: nil, userInfo: nil)
        

    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
    }
    func ResponseNew(_ message:Notification)
    {
        print("Response = \(message.object!)", terminator: "")
        jsondict = message.object as! NSDictionary
        
        
        let arrJsonDictKeys : NSArray = jsondict.allKeys as NSArray
        let arrFieldNameKeys : NSArray = arrFieldNames as NSArray //arrSuccessPlaceHolderValues.allKeys
        
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "", ascending: true)
        arrFieldNameKeysSorted = arrFieldNameKeys.sortedArray(using: [descriptor])
        
        let descriptor2: NSSortDescriptor = NSSortDescriptor(key: "", ascending: true)
        var arrJsonDictSortedKeys = arrJsonDictKeys.sortedArray(using: [descriptor2])
        
        arrJsonDictSortedKeys.remove(at: 25)
        
        // print("arrFieldNames: \(arrFieldNameKeysSorted)")
        // print("\narrJsonDictSortedKeys: \(arrJsonDictSortedKeys)")
        
        
        for indx in 0..<arrFieldNameKeysSorted.count {
            
            print(indx)
            
            let dict : [String :String]
            
            // if arrJsonDictSortedKeys[indx] as! String != "ResponseCode" {
            
            dict = [ arrFieldNameKeysSorted[indx] as! String : jsondict.value(forKey: arrJsonDictSortedKeys[indx] as! String) as Any as! String]
            
            //  }
            keyValuePairArr.append(dict as [String : AnyObject])
            
            /*
             for (indx,_) in arrSuccessPlaceHolderValuesSorted.enumerated() {
             
             if arrJsonDictSortedKeys[indx] as! String != "ResponseCode" {
             
             let dict : [String :String] = [ arrSuccessPlaceHolderValuesSorted[indx] as! String : jsondict.value(forKey: arrJsonDictSortedKeys[indx] as! String) as Any as! String]
             
             
             arrSuccessPlaceHolderValues[indx] = dict
             }
             
             */
            
            
        }
        
        tblSuccess .reloadData()
        
        for  i in 0..<Int((self.navigationController?.viewControllers.count)!)
        {
            if(self.navigationController?.viewControllers[i].isKind(of: PackageListingVC.self) == true)
            {
                let pckgVC : PackageListingVC = self.navigationController?.viewControllers[i] as! PackageListingVC
                
                pckgVC.strPaymentStatus = "Success"
                
                break;
            }
            
        }
        
    }
    
    // MARK:- UITableview Delegates and DataSource
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60.0;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFieldNames.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell:SuccessAndFailureTableViewCell = tblSuccess.dequeueReusableCell(withIdentifier: "successCell") as! SuccessAndFailureTableViewCell!
        
      // print("keyValuePairArr[indexPath.row]: \(String(describing: keyValuePairArr[indexPath.row]))")
        
        let dict = keyValuePairArr[indexPath.row]
        
        for (key, value) in dict {
           
            print("\(key) -> \(value)")
            
            cell.lblLeft.text = key
            cell.lblRight.text = value as? String
        }
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    //MARK:- Button Action
    
    @IBAction func btnOkAction(_ sender: Any) {
        
        for  i in 0..<Int((self.navigationController?.viewControllers.count)!)
        {
            if(self.navigationController?.viewControllers[i].isKind(of: UITabBarController.self) == true)
            {
               // _ =  self.navigationController?.popToViewController(self.navigationController!.viewControllers[i] as! MyProfileVC, animated: true)
                
                let someTabIndex = 3
                // Get the tabBar
                let t : UITabBarController = self.navigationController?.viewControllers[i] as! UITabBarController
                // Change the selected tab item to what you want
                t.selectedIndex = someTabIndex
                // Pop the navigation controller of that index
                
                // let pkgvc = t.viewControllers![someTabIndex] as! PackageListingVC
                
                let pkgvc = self.navigationController?.viewControllers[1] as! PackageListingVC
                
                let v = t.viewControllers?[someTabIndex]
                if let n = v?.navigationController {
                    pkgvc.removeObserver(pkgvc, forKeyPath: "strPaymentStatus")
                    n.popToRootViewController(animated: true)
                }
                break;
            }
            
        }

    }

@IBAction func submitClk(_ sender: AnyObject)
{
    for  i in 0..<Int((self.navigationController?.viewControllers.count)!)
    {
        if(self.navigationController?.viewControllers[i].isKind(of: PackageListingVC.self) == true)
        {
            _ =  self.navigationController?.popToViewController(self.navigationController!.viewControllers[i] as! PackageListingVC, animated: true)
            
            break;
        }
        
    }
    
    
    }

     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
