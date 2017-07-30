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


class FailViewController: UIViewController {
    var jsondict = NSDictionary()
    
    @IBOutlet var scrollView: UIScrollView!
   
    @IBOutlet var lbl1: UILabel!
    @IBOutlet var lbl2: UILabel!
    @IBOutlet var lbl3: UILabel!
    @IBOutlet var lbl4: UILabel!
    @IBOutlet var lbl5: UILabel!
    @IBOutlet var lbl6: UILabel!
    @IBOutlet var lbl7: UILabel!
    @IBOutlet var lbl8: UILabel!
    @IBOutlet var lbl9: UILabel!
    @IBOutlet var lbl10: UILabel!
    @IBOutlet var lbl11: UILabel!
    @IBOutlet var lbl12: UILabel!
    @IBOutlet var lbl13: UILabel!
    @IBOutlet var lbl14: UILabel!
    @IBOutlet var lbl15: UILabel!
    @IBOutlet var lbl16: UILabel!
    @IBOutlet var lbl17: UILabel!
    @IBOutlet var lbl18: UILabel!
    @IBOutlet var lbl19: UILabel!
    @IBOutlet var lbl20: UILabel!
    @IBOutlet var lbl21: UILabel!
    @IBOutlet var lbl22: UILabel!
    @IBOutlet var lbl23: UILabel!
    @IBOutlet var lbl24: UILabel!
    @IBOutlet var lbl25: UILabel!
    @IBOutlet var lbl26: UILabel!
    @IBOutlet var lbl27: UILabel!
    @IBOutlet var lbl28: UILabel!
    @IBOutlet var lbl29: UILabel!
    
    var error: NSError?


override func viewDidLoad() {
    super.viewDidLoad()
    
    // jsondict = NSMutableDictionary()
    
    NotificationCenter.default.addObserver(self, selector: #selector(FailViewController.ResponseNew(_:)), name: NSNotification.Name(rawValue: "JSON_NEW"), object: nil)
    NotificationCenter.default.post(name: Notification.Name(rawValue: "JSON_DICT"), object: nil, userInfo: nil)
    
    scrollView.contentSize = CGSize(width: 0, height: 2600)
    
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
    
    let accID:NSString = jsondict.value(forKey: "AccountId") as! NSString
    lbl1.text = accID as String

    let amtStr:NSString = jsondict.value(forKey: "Amount") as! NSString
    lbl2.text = amtStr as String

    let billAddStr:NSString = jsondict.value(forKey: "BillingAddress") as! NSString
    lbl3.text = billAddStr as String

    let billCityStr:NSString = jsondict.value(forKey: "BillingCity") as! NSString
    lbl4.text = billCityStr as String

    let billCounStr:NSString = jsondict.value(forKey: "BillingCountry") as! NSString
    lbl5.text = billCounStr as String

    let billNameStr:NSString = jsondict.value(forKey: "BillingName") as! NSString
    lbl6.text = billNameStr as String

    let billPhoneStr:NSString = jsondict.value(forKey: "BillingPhone") as! NSString
    lbl7.text = billPhoneStr as String

    let billPostalStr:NSString = jsondict.value(forKey: "BillingPostalCode") as! NSString
    lbl8.text = billPostalStr as String

    let billStateStr:NSString = jsondict.value(forKey: "BillingState") as! NSString
    lbl9.text = billStateStr as String
    
    let billEmailStr:NSString = jsondict.value(forKey: "BillingEmail") as! NSString
    lbl10.text = billEmailStr as String

    let dateCreStr:NSString = jsondict.value(forKey: "DateCreated") as! NSString
    lbl11.text = dateCreStr as String

    let delAddStr:NSString = jsondict.value(forKey: "DeliveryAddress") as! NSString
    lbl12.text = delAddStr as String

    let delCityStr:NSString = jsondict.value(forKey: "DeliveryCity") as! NSString
    lbl13.text = delCityStr as String

    let delCounStr:NSString = jsondict.value(forKey: "DeliveryCountry") as! NSString
    lbl14.text = delCounStr as String

    let delNameStr:NSString = jsondict.value(forKey: "DeliveryName") as! NSString
    lbl15.text = delNameStr as String

    let delPhStr:NSString = jsondict.value(forKey: "DeliveryPhone") as! NSString
    lbl16.text = delPhStr as String

    let delPostStr:NSString = jsondict.value(forKey: "DeliveryPostalCode") as! NSString
    lbl17.text = delPostStr as String

    let delStateStr:NSString = jsondict.value(forKey: "DeliveryState") as! NSString
    lbl18.text = delStateStr as String

    let descStr:NSString = jsondict.value(forKey: "Description") as! NSString
    lbl19.text = descStr as String

    let isFlagStr:NSString = jsondict.value(forKey: "IsFlagged") as! NSString
    lbl20.text = isFlagStr as String

    let mercStr:NSString = jsondict.value(forKey: "MerchantRefNo") as! NSString
    lbl21.text = mercStr as String

    let modeStr:NSString = jsondict.value(forKey: "Mode") as! NSString
    lbl22.text = modeStr as String

    let payIDStr:NSString = jsondict.value(forKey: "PaymentId") as! NSString
    lbl23.text = payIDStr as String

    let payModeStr:NSString = jsondict.value(forKey: "PaymentMode") as! NSString
    lbl24.text = payModeStr as String

    let payStautsStr:NSString = jsondict.value(forKey: "PaymentStatus") as! NSString
    lbl25.text = payStautsStr as String

    //let resCodeStr:NSString = jsondict.valueForKey("ResponseCode") as! NSString
   // let resCodeStr:NSInteger = jsondict.valueForKey("ResponseCode") as! NSInteger
   // lbl26.text = resCodeStr as String
    
    lbl26.text = ""

    let reMsgStr:NSString = jsondict.value(forKey: "ResponseMessage") as! NSString
    lbl27.text = reMsgStr as String

    let secHashStr:NSString = jsondict.value(forKey: "SecureHash") as! NSString
    lbl28.text = secHashStr as String

    let transStr:NSString = jsondict.value(forKey: "TransactionId") as! NSString
    lbl29.text = transStr as String
    
    
    //
    //lbl30.text = accID as String

    
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

