//
//  FailViewController.swift
//  Demo
//
//  Created by Martin Prabhu on 5/26/16.
//
//

import UIKit
import SystemConfiguration
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


class FailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var jsondict = NSDictionary()
    
    @IBOutlet var tblFailure: UITableView!
    
    var arrFieldNameKeysSorted : [Any] = []
    
    
    var keyValuePairArr:[Dictionary<String, AnyObject>] = []
    
    var arrFieldNames = ["Account Id","Amount","Billing Address" ,"Billing City","Billing Country","Billing Name" ,"Billing Phone","Billing PostalCode", "Billing State", "Billing Email" , "Date Created", "Delivery Address", "Delivery City", "Delivery Country", "Delivery Name", "Delivery Phone", "Delivery PostalCode", "Delivery State", "Description", "IsFlagged", "Merchant Ref. No.", "Mode", "Payment Id", "Payment Mode", "Payment Status", "Response Message", "Secure Hash", "Transaction Id"]
    
    
    var error: NSError?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // jsondict = NSMutableDictionary()
        
        NotificationCenter.default.addObserver(self, selector: #selector(FailViewController.ResponseNew(_:)), name: NSNotification.Name(rawValue: "JSON_NEW"), object: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "JSON_DICT"), object: nil, userInfo: nil)
        
        // Do any additional setup after loading the view.
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
        let arrFieldNameKeys : NSArray = arrFieldNames as NSArray
        
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "", ascending: true)
        arrFieldNameKeysSorted = arrFieldNameKeys.sortedArray(using: [descriptor])
        
        let descriptor2: NSSortDescriptor = NSSortDescriptor(key: "", ascending: true)
        var arrJsonDictSortedKeys = arrJsonDictKeys.sortedArray(using: [descriptor2])
        
        arrJsonDictSortedKeys.remove(at: 25)
       
        for indx in 0..<arrFieldNameKeysSorted.count {
            
            print(indx)
            
            let dict : [String :String]
            dict = [ arrFieldNameKeysSorted[indx] as! String : jsondict.value(forKey: arrJsonDictSortedKeys[indx] as! String) as Any as! String]
            keyValuePairArr.append(dict as [String : AnyObject])
        }
        tblFailure .reloadData()
        
        
    }
    
    // MARK:- UITableview Delegates and DataSource
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60.0;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFieldNames.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:SuccessAndFailureTableViewCell = tblFailure.dequeueReusableCell(withIdentifier: "failureCell") as! SuccessAndFailureTableViewCell!
        
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
    
    
    @IBAction func tryAgainAction(_ sender: AnyObject) {
        let paymentView: PaymentModeViewController = PaymentModeViewController()
        
        paymentView.paymentAmtString = UserDefaults.standard.object(forKey: "paymentAmtString") as? String
        paymentView.descriptionString = UserDefaults.standard.object(forKey: "descriptionString") as? String
        paymentView.strSaleAmount = UserDefaults.standard.object(forKey: "strSaleAmount") as? String
        paymentView.strCurrency = UserDefaults.standard.object(forKey: "strCurrency") as? String
        paymentView.strDisplayCurrency = UserDefaults.standard.object(forKey: "strDisplayCurrency") as? String
        paymentView.strDescription = UserDefaults.standard.object(forKey: "strDescription") as? String
        paymentView.strBillingName = UserDefaults.standard.object(forKey: "strBillingName") as? String
        paymentView.strBillingAddress = UserDefaults.standard.object(forKey: "strBillingAddress") as? String
        paymentView.strBillingCity = UserDefaults.standard.object(forKey: "strBillingCity") as? String
        paymentView.strBillingState = UserDefaults.standard.object(forKey: "strBillingState") as? String
        paymentView.strBillingPostal = UserDefaults.standard.object(forKey: "strBillingPostal") as? String
        paymentView.strBillingCountry = UserDefaults.standard.object(forKey: "strBillingCountry") as? String
        paymentView.strBillingEmail = UserDefaults.standard.object(forKey: "strBillingEmail") as? String
        paymentView.strBillingTelephone = UserDefaults.standard.object(forKey: "strBillingTelephone") as? String
        paymentView.strDeliveryName = UserDefaults.standard.object(forKey: "strDeliveryName") as? String
        paymentView.strDeliveryAddress = UserDefaults.standard.object(forKey: "strDeliveryAddress") as? String
        paymentView.strDeliveryCity = UserDefaults.standard.object(forKey: "strDeliveryCity") as? String
        paymentView.strDeliveryState = UserDefaults.standard.object(forKey: "strDeliveryState") as? String
        paymentView.strDeliveryPostal = UserDefaults.standard.object(forKey: "strDeliveryPostal") as? String
        paymentView.strDeliveryCountry = UserDefaults.standard.object(forKey: "strDeliveryCountry") as? String
        paymentView.strDeliveryTelephone = UserDefaults.standard.object(forKey: "strDeliveryTelephone") as? String
        paymentView.reference_no = UserDefaults.standard.object(forKey: "reference_no") as? String
        
        
        // for (var i = 0; i < self.navigationController?.viewControllers.count; i += 1)
        
        
        for  i in 0..<Int((self.navigationController?.viewControllers.count)!)
        {
            if(self.navigationController?.viewControllers[i].isKind(of: PaymentModeViewController.self) == true)
            {
                _ =  self.navigationController?.popToViewController(self.navigationController!.viewControllers[i] as! PaymentModeViewController, animated: true)
                
                break;
            }
            
        }
    }
    
    @IBAction func cancelClk(_ sender: AnyObject)
    {
        var index: Int = 0
        var status: Bool = false
        
        for  i in 0..<Int((self.navigationController?.viewControllers.count)!)
        {
            if(self.navigationController?.viewControllers[i].isKind(of: PackageListingVC.self) == true)
            {
                index = i;
                status = true;
            }
            
        }
        if status
        {
            self.navigationController?.popToViewController(self.navigationController!.viewControllers[index] as! PackageListingVC, animated: true)
        }
        else
        {
            self.navigationController!.pushViewController(self.navigationController!.viewControllers[index] as! PackageListingVC, animated: false)
        }
        
        
    }
    
    
    
}

