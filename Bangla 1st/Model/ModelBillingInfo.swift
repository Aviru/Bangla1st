//
//  ModelBillingInfo.swift
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 30/07/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

import UIKit

class ModelBillingInfo: ModelBaseClass,NSCoding {
    
    var strBillingName: String?
    var strBillingAddress: String?
    var strBillingCity: String?
    var strBillingState: String?
    var strBillingPostal: String?
    var strBillingCountry: String?
    var strBillingEmail: String?
    var strBillingPhone: String?
    var strDeliveryName: String?
    var strDeliveryAddress: String?
    var strDeliveryCity: String?
    var strDeliveryState: String?
    var strDeliveryPostal: String?
    var strDeliveryCountry: String?
    var strDeliveryPhone: String?
    
    // MARK: NSCoding
    
    init(strBillingName : String, strBillingAddress: String, strBillingCity : String, strBillingState : String, strBillingPostal : String, strBillingCountry : String, strBillingEmail : String, strBillingPhone : String, strDeliveryName : String, strDeliveryAddress : String, strDeliveryCity : String, strDeliveryState : String, strDeliveryPostal : String, strDeliveryCountry : String, strDeliveryPhone : String) {
        
            self.strBillingName = strBillingName
            self.strBillingAddress = strBillingAddress
            self.strBillingCity = strBillingCity
            self.strBillingState = strBillingState
            self.strBillingPostal = strBillingPostal
            self.strBillingCountry = strBillingCountry
            self.strBillingEmail = strBillingEmail
            self.strBillingPhone = strBillingPhone
            self.strDeliveryName = strDeliveryName
            self.strDeliveryAddress = strDeliveryAddress
            self.strDeliveryCity = strDeliveryCity
            self.strDeliveryState = strDeliveryState
            self.strDeliveryPostal = strDeliveryPostal
            self.strDeliveryCountry = strDeliveryCountry
            self.strDeliveryPhone = strDeliveryPhone
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let BillingName = decoder.decodeObject(forKey: "billingName") as? String,let BillingAddress = decoder.decodeObject(forKey: "billingAddress") as? String,let BillingCity = decoder.decodeObject(forKey: "billingCity") as? String,let BillingState = decoder.decodeObject(forKey: "billingState") as? String,let BillingPostal = decoder.decodeObject(forKey: "billingPostal") as? String,let BillingCountry = decoder.decodeObject(forKey: "billingCountry") as? String,let BillingEmail = decoder.decodeObject(forKey: "billingEmail") as? String,let BillingPhone = decoder.decodeObject(forKey: "billingPhone") as? String,let DeliveryName = decoder.decodeObject(forKey: "deliveryName") as? String,let DeliveryAddress = decoder.decodeObject(forKey: "deliveryAddress") as? String,let DeliveryCity = decoder.decodeObject(forKey: "deliveryCity") as? String,let DeliveryState = decoder.decodeObject(forKey: "deliveryState") as? String,let DeliveryPostal = decoder.decodeObject(forKey: "deliveryPostal") as? String,let DeliveryCountry = decoder.decodeObject(forKey: "deliveryCountry") as? String,let DeliveryPhone = decoder.decodeObject(forKey: "deliveryPhone") as? String
            
            else {
                return nil
        }
        
        self.init(strBillingName: BillingName, strBillingAddress: BillingAddress, strBillingCity: BillingCity, strBillingState: BillingState, strBillingPostal: BillingPostal, strBillingCountry: BillingCountry, strBillingEmail: BillingEmail, strBillingPhone: BillingPhone, strDeliveryName: DeliveryName, strDeliveryAddress: DeliveryAddress, strDeliveryCity: DeliveryCity, strDeliveryState: DeliveryState, strDeliveryPostal: DeliveryPostal, strDeliveryCountry: DeliveryCountry, strDeliveryPhone: DeliveryPhone)
    }
    
    
    func encode(with aCoder: NSCoder)  {
        aCoder.encode(self.strBillingName, forKey: "billingName")
        aCoder.encode(self.strBillingAddress, forKey: "billingAddress")
        aCoder.encode(self.strBillingCity, forKey: "billingCity")
        aCoder.encode(self.strBillingState, forKey: "billingState")
        aCoder.encode(self.strBillingPostal, forKey: "billingPostal")
        aCoder.encode(self.strBillingCountry, forKey: "billingCountry")
        aCoder.encode(self.strBillingEmail, forKey: "billingEmail")
        aCoder.encode(self.strBillingPhone, forKey: "billingPhone")
        aCoder.encode(self.strDeliveryName, forKey: "deliveryName")
        aCoder.encode(self.strDeliveryAddress, forKey: "deliveryAddress")
        aCoder.encode(self.strDeliveryCity, forKey: "deliveryCity")
        aCoder.encode(self.strDeliveryState, forKey: "deliveryState")
        aCoder.encode(self.strDeliveryPostal, forKey: "deliveryPostal")
        aCoder.encode(self.strDeliveryCountry, forKey: "deliveryCountry")
        aCoder.encode(self.strDeliveryPhone, forKey: "deliveryPhone")
    }

   
    init(infoDic: NSDictionary) {
        
        if let BillingName = infoDic["billingName"] as? String
        {
            self.strBillingName = BillingName
        }
        else
        {
            self.strBillingName = ""
        }
        
        if let BillingAddress = infoDic["billingAddress"] as? String
        {
            self.strBillingAddress = BillingAddress
        }
        else
        {
            self.strBillingAddress = ""
        }
        
        if let BillingCity = infoDic["billingCity"]as? String
        {
            self.strBillingCity = BillingCity
        }
        else
        {
            self.strBillingCity = ""
        }
        
        if let BillingState = infoDic["billingState"]as? String
        {
            self.strBillingState = BillingState
        }
        else
        {
            self.strBillingState = ""
        }
        
        if let BillingPostal = infoDic["billingPostal"]as? String
        {
            self.strBillingPostal = BillingPostal
        }
        else
        {
            self.strBillingPostal = ""
        }
        
        if let BillingCountry = infoDic["billingCountry"]as? String
        {
            self.strBillingCountry = BillingCountry
        }
        else
        {
            self.strBillingCountry = ""
        }
        
        if let BillingEmail = infoDic["billingEmail"]as? String
        {
            self.strBillingEmail = BillingEmail
        }
        else
        {
            self.strBillingEmail = ""
        }
        
        if let BillingPhone = infoDic["billingPhone"]as? String
        {
            self.strBillingPhone = BillingPhone
        }
        else
        {
            self.strBillingPhone = ""
        }
        
        if let DeliveryName = infoDic["deliveryName"]as? String
        {
            self.strDeliveryName = DeliveryName
        }
        else
        {
            self.strDeliveryName = ""
        }
        
        if let DeliveryAddress = infoDic["deliveryAddress"]as? String
        {
            self.strDeliveryAddress = DeliveryAddress
        }
        else
        {
            self.strDeliveryAddress = ""
        }
        
        if let DeliveryCity = infoDic["deliveryCity"]as? String
        {
            self.strDeliveryCity = DeliveryCity
        }
        else
        {
            self.strDeliveryCity = ""
        }
        
        if let DeliveryState = infoDic["deliveryState"]as? String
        {
            self.strDeliveryState = DeliveryState
        }
        else
        {
            self.strDeliveryState = ""
        }
        
        if let DeliveryPostal = infoDic["deliveryPostal"]as? String
        {
            self.strDeliveryPostal = DeliveryPostal
        }
        else
        {
            self.strDeliveryPostal = ""
        }
        
        if let DeliveryCountry = infoDic["deliveryCountry"]as? String
        {
            self.strDeliveryCountry = DeliveryCountry
        }
        else
        {
            self.strDeliveryCountry = ""
        }
        
        if let DeliveryPhone = infoDic["deliveryPhone"]as? String
        {
            self.strDeliveryPhone = DeliveryPhone
        }
        else
        {
            self.strDeliveryPhone = ""
        }
        
    }

}
