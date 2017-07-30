//
//  AddressViewController.swift
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 30/07/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

import UIKit

// MARK: - Extension

extension String
{
    func trim() -> String
    {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}

extension AddressViewController: UITextFieldDelegate{
    
    func addToolBar(textField: UITextField, section : Int){
        
        selectedsection = section
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(AddressViewController.donePressed))
       // let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddressViewController.cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false) //cancelButton,
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    func donePressed(){
        
        view.endEditing(true)
        if isViewUp {
            viewDown()
        }
        
    }
    func cancelPressed(){
        view.endEditing(true) // or do something
    }
}

//MARK:- Structure

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6_7          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P_7P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}

//MARK:-

class AddressViewController: BaseVC,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tblAddress: UITableView!
    @IBOutlet var imgVwCheckBoxIcon: UIImageView!
    @IBOutlet var navBarContainerView: UIView!
    
    
    
    var globalTextField : UITextField!
    var isViewUp : Bool! = false
    var isSameAsBillingInfo : Bool! = false
    var isSaveBillingInfoChecked : Bool! = false
    var objModelPackage : ModelPackageListing!
    var RowCount = 0
    var selectedsection : Int!
    
    

    
    var strBillingName = "", strBillingAddress = "", strBillingCity = "", strBillingState = "", strBillingPostal = "", strBillingCountry = "", strBillingEmail = "", strBillingPhone = "", strDeliveryName = "", strDeliveryAddress = "", strDeliveryCity = "", strDeliveryState = "", strDeliveryPostal = "", strDeliveryCountry = "",strDeliveryPhone = ""
    
    
    var arrBillingPlaceHolderValues: [String] = ["Billing Name","Billing Address","Billing City","Billing State","Billing Postal","Billing Country","Billing Email","Billing Telephone"]
    
    var arrDeliveryPlaceHolderValues : [String] = ["Delivery Name","Delivery Address","Delivery City","Delivery State", "Delivery Postal", "Delivery Country", "Delivery Telephone"]
    
    var arrBillingIcons: [String] = ["user.png","location.png", "location.png", "location.png","zip_code.png", "country.png", "email_icon.png", "phone.png"]
    
    var arrDeliveryIcons: [String] = ["user.png","location.png", "location.png", "location.png","zip_code.png", "country.png", "phone.png"]
    
   //MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let customFont = UIFont.init(name: "BerlinSansFB-Reg", size: 20.0)
        
        
        self.initWithParentView(navBarContainerView, isTranslateToAutoResizingMaskNeeded: false, leftButton: true, rightButton: false, navigationTitle: "Billing Information", navigationTitleTextAlignment: .center, navigationTitleFontType: customFont, leftImageName: "back_arrow.png", leftLabelName: " Back", rightImageName: nil, rightLabelName: nil)
        
        self.navBar.navBarLeftButtonOutlet.addTarget(self, action: #selector(backBtnTap(_:)), for: .touchUpInside)
        
        tblAddress.register(UINib(nibName: "AddressTableViewCell", bundle: nil), forCellReuseIdentifier: "addressCell")
    }
    
    
    // MARK:- UITableview Delegates and DataSource
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60.0;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 45.0;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return 8;
        }
        else{
            //self.firstSecRowCount = 7
            return 7;
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let VwSectionHeader : SectionHeaderView = Bundle.main.loadNibNamed("SectionHeaderView", owner: self, options: nil)?.last as! SectionHeaderView
        
        if section == 0 {
            
            VwSectionHeader.lblSectionHeader.text = "Billing Information"
            VwSectionHeader.btnCheckBoxOutlet.isUserInteractionEnabled = false
            VwSectionHeader.imgVwCheckBoxIcon.isHidden = true
            VwSectionHeader.lblSameBillingInfo.isHidden = true
        }
        else{
            
            VwSectionHeader.lblSectionHeader.text = "Delivery Information"
            VwSectionHeader.btnCheckBoxOutlet.isUserInteractionEnabled = true
            VwSectionHeader.imgVwCheckBoxIcon.isHidden = false
            VwSectionHeader.lblSameBillingInfo.isHidden = false
            
            if self.isSameAsBillingInfo {
                
                VwSectionHeader.imgVwCheckBoxIcon.image = UIImage.init(named: "box_tick.png")
            }
            else {
                VwSectionHeader.imgVwCheckBoxIcon.image = UIImage.init(named: "box_empty.png")

            }
            
            VwSectionHeader.setButtonCheckboxTapFunction {
                
                if self.isSameAsBillingInfo {
                    
                    self.isSameAsBillingInfo = false
                    VwSectionHeader.imgVwCheckBoxIcon.image = UIImage.init(named: "box_empty.png")
                    
                    self.arrDeliveryPlaceHolderValues[0] = "Delivery Name"
                    self.arrDeliveryPlaceHolderValues[1] = "Delivery Address"
                    self.arrDeliveryPlaceHolderValues[2] = "Delivery City"
                    self.arrDeliveryPlaceHolderValues[3] = "Delivery State"
                    self.arrDeliveryPlaceHolderValues[4] = "Delivery Postal"
                    self.arrDeliveryPlaceHolderValues[5] = "Delivery Country"
                    self.arrDeliveryPlaceHolderValues[6] = "Delivery Telephone"
                    
                    self.strDeliveryName = ""
                    self.strDeliveryAddress = ""
                    self.strDeliveryCity = ""
                    self.strDeliveryState = ""
                    self.strDeliveryPostal = ""
                    self.strDeliveryCountry = ""
                    self.strDeliveryPhone = ""
                    
                    let indexPath = [IndexPath(row: 0, section: 1),IndexPath(row: 1, section: 1),IndexPath(row: 2, section: 1),IndexPath(row: 3, section: 1),IndexPath(row: 4, section: 1),IndexPath(row: 5, section: 1),IndexPath(row: 6, section: 1)]
                    
                    self.tblAddress.reloadRows(at: indexPath, with: .none)
                    
                }
                else {
                    
                    self.isSameAsBillingInfo = true
                    VwSectionHeader.imgVwCheckBoxIcon.image = UIImage.init(named: "box_tick.png")
                    
                    if( self.strBillingName != "" && self.strBillingAddress != "" && self.strBillingCity != "" && self.strBillingState != "" && self.strBillingPostal != "" && self.strBillingCountry != "" &&  self.strBillingPhone != "") {
                        
                        self.arrDeliveryPlaceHolderValues[0] = self.strBillingName
                        self.arrDeliveryPlaceHolderValues[1] = self.strBillingAddress
                        self.arrDeliveryPlaceHolderValues[2] = self.strBillingCity
                        self.arrDeliveryPlaceHolderValues[3] = self.strBillingState
                        self.arrDeliveryPlaceHolderValues[4] = self.strBillingPostal
                        self.arrDeliveryPlaceHolderValues[5] = self.strBillingCountry
                        self.arrDeliveryPlaceHolderValues[6] = self.strBillingPhone
                        
                        self.strDeliveryName = self.strBillingName
                        self.strDeliveryAddress = self.strBillingAddress
                        self.strDeliveryCity = self.strBillingCity
                        self.strDeliveryState = self.strBillingState
                        self.strDeliveryPostal = self.strBillingPostal
                        self.strDeliveryCountry = self.strBillingCountry
                        self.strDeliveryPhone = self.strBillingPhone
                        
                        let indexPath = [IndexPath(row: 0, section: 1),IndexPath(row: 1, section: 1),IndexPath(row: 2, section: 1),IndexPath(row: 3, section: 1),IndexPath(row: 4, section: 1),IndexPath(row: 5, section: 1),IndexPath(row: 6, section: 1)]
                        
                        self.tblAddress.reloadRows(at: indexPath, with: .none)
                    }
                    
                    
                }
            }

        }
        
        return VwSectionHeader
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:AddressTableViewCell = tblAddress.dequeueReusableCell(withIdentifier: "addressCell") as! AddressTableViewCell!
        
        if indexPath.section == 0 {
            cell.txtFieldAddress.placeholder = arrBillingPlaceHolderValues[indexPath.row]
            cell.imgVwIcon.image = UIImage(named: arrBillingIcons[indexPath.row])
            //firstSecRowCount = 7
        }
        else {
            
            if isSameAsBillingInfo {
                
                cell.txtFieldAddress.text = arrDeliveryPlaceHolderValues[indexPath.row]
                cell.imgVwIcon.image = UIImage(named: arrDeliveryIcons[indexPath.row])
            }
            else {
                cell.txtFieldAddress.placeholder = arrDeliveryPlaceHolderValues[indexPath.row]
                cell.txtFieldAddress.text = ""
                cell.imgVwIcon.image = UIImage(named: arrDeliveryIcons[indexPath.row])
                
            }
            
            /*
             firstSecRowCount += 1
             
             print("firstSecRowCount: \(firstSecRowCount)")
             
             if firstSecRowCount < arrDeliveryPlaceHolderValues.count {
             
             cell.txtFieldAddress.placeholder = arrDeliveryPlaceHolderValues[firstSecRowCount]
             cell.imgVwIcon.image = UIImage(named: arrDeliveryIcons[firstSecRowCount])
             
             if firstSecRowCount == 14 {
             firstSecRowCount = 7
             }
             }
             */
            
        }
        
        cell.txtFieldAddress.delegate = self
        
        cell.txtFieldAddress.tag = indexPath.row
       
        cell.txtFieldAddress .setValue(UIColor.init(colorLiteralRed: 255.0/255.0, green: 83.0/255.0, blue: 31.0/255.0, alpha: 1.0), forKeyPath: "_placeholderLabel.textColor")
        
        cell.txtFieldAddress.autocorrectionType = .no
        
        cell.imgVwTextFieldBorder.layer.borderColor = UIColor.gray.cgColor
        cell.imgVwTextFieldBorder.layer.borderWidth = 1.0
        cell.imgVwTextFieldBorder.layer.cornerRadius = 2.0
        cell.txtFieldAddress.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        
        
        
        cell.txtFieldAddress.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        
        
       
        if indexPath.row == 6 {
            cell.txtFieldAddress.keyboardType = UIKeyboardType.emailAddress
        }
        
        if indexPath.row == 4 || indexPath.row == 12{
            
            cell.txtFieldAddress.keyboardType = UIKeyboardType.numberPad
        }
        
        if indexPath.row == 7 || indexPath.row == 14{
            
            cell.txtFieldAddress.keyboardType = UIKeyboardType.phonePad
        }
        
        else {
            
            if indexPath.row == 0 {
                cell.txtFieldAddress.autocapitalizationType = .words
            }
       }
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    // MARK: - Textfield Delegates
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        globalTextField = textField
        
        let indxPath = indexPathForTextField(textField: globalTextField)
        
        if indxPath.section == 0 {
            
            if textField.tag == 4 || textField.tag == 7
            {
                addToolBar(textField: globalTextField, section: indxPath.section)
            }
        }
        else {
            
            if textField.tag == 4 || textField.tag == 6
            {
                addToolBar(textField: globalTextField, section: indxPath.section)
            }
            
            if textField.tag == 4 || textField.tag == 5 || textField.tag == 6  {
                
                if !isViewUp {
                    viewUp()
                }
            }
        }
        
  }
    
    func textFieldDidChange(_ textField: UITextField) {
        
        let indxPath = indexPathForTextField(textField: globalTextField)
        
        if indxPath.section == 0 {
            
            if (textField.tag == 0) {
                
                if let billingName = textField.text?.trim() {
                    
                    strBillingName = billingName
                    
                    if (strBillingName.characters.count > 0)
                    {
                        arrBillingPlaceHolderValues.remove(at: textField.tag)
                        arrBillingPlaceHolderValues.insert(strBillingName, at: textField.tag)
                    }
                    else
                    {
                        arrBillingPlaceHolderValues.remove(at: textField.tag)
                        arrBillingPlaceHolderValues.insert("Billing Name", at: textField.tag)
                    }
                    
                }
                else{
                    
                    strBillingName = ""
                    arrBillingPlaceHolderValues.remove(at: textField.tag)
                    arrBillingPlaceHolderValues.insert("Billing Name", at: textField.tag)
                }
                
            }
            else if(textField.tag == 1){
                
                if let billingAddress = textField.text?.trim() {
                    
                    strBillingAddress = billingAddress
                    
                    if (strBillingAddress.characters.count > 0)
                    {
                        arrBillingPlaceHolderValues.remove(at: textField.tag)
                        arrBillingPlaceHolderValues.insert(strBillingAddress, at: textField.tag)
                    }
                    else
                    {
                        arrBillingPlaceHolderValues.remove(at: textField.tag)
                        arrBillingPlaceHolderValues.insert("Billing Address", at: textField.tag)
                    }
                    
                }
                else{
                    
                    strBillingAddress = ""
                    arrBillingPlaceHolderValues.remove(at: textField.tag)
                    arrBillingPlaceHolderValues.insert("Billing Address", at: textField.tag)
                }
                
            }
            else if(textField.tag == 2){
                
                if let billingCity = textField.text?.trim() {
                    
                    strBillingCity = billingCity
                    
                    if (strBillingCity.characters.count > 0)
                    {
                        arrBillingPlaceHolderValues.remove(at: textField.tag)
                        arrBillingPlaceHolderValues.insert(strBillingCity, at: textField.tag)
                    }
                    else
                    {
                        arrBillingPlaceHolderValues.remove(at: textField.tag)
                        arrBillingPlaceHolderValues.insert("Billing City", at: textField.tag)
                    }
                    
                }
                else{
                    
                    strBillingCity = ""
                    arrBillingPlaceHolderValues.remove(at: textField.tag)
                    arrBillingPlaceHolderValues.insert("Billing City", at: textField.tag)
                }
                
            }
            else if(textField.tag == 3){
                
                if let billingState = textField.text?.trim() {
                    
                    strBillingState = billingState
                    
                    if (strBillingState.characters.count > 0)
                    {
                        arrBillingPlaceHolderValues.remove(at: textField.tag)
                        arrBillingPlaceHolderValues.insert(strBillingState, at: textField.tag)
                    }
                    else
                    {
                        arrBillingPlaceHolderValues.remove(at: textField.tag)
                        arrBillingPlaceHolderValues.insert("Billing State", at: textField.tag)
                    }
                    
                }
                else{
                    
                    strBillingState = ""
                    arrBillingPlaceHolderValues.remove(at: textField.tag)
                    arrBillingPlaceHolderValues.insert("Billing State", at: textField.tag)
                }
                
            }
                
            else if(textField.tag == 4){
                
                if let billingPostal = textField.text?.trim() {
                    
                    strBillingPostal = billingPostal
                    
                    if (strBillingPostal.characters.count > 0)
                    {
                        arrBillingPlaceHolderValues.remove(at: textField.tag)
                        arrBillingPlaceHolderValues.insert(strBillingPostal, at: textField.tag)
                    }
                    else
                    {
                        arrBillingPlaceHolderValues.remove(at: textField.tag)
                        arrBillingPlaceHolderValues.insert("Billing Postal", at: textField.tag)
                    }
                    
                }
                else{
                    
                    strBillingPostal = ""
                    arrBillingPlaceHolderValues.remove(at: textField.tag)
                    arrBillingPlaceHolderValues.insert("Billing Postal", at: textField.tag)
                }
                
            }
                
            else if(textField.tag == 5){
                
                if let billingCountry = textField.text?.trim() {
                    
                    strBillingCountry = billingCountry
                    
                    if (strBillingCountry.characters.count > 0)
                    {
                        arrBillingPlaceHolderValues.remove(at: textField.tag)
                        arrBillingPlaceHolderValues.insert(strBillingCountry, at: textField.tag)
                    }
                    else
                    {
                        arrBillingPlaceHolderValues.remove(at: textField.tag)
                        arrBillingPlaceHolderValues.insert("Billing Country", at: textField.tag)
                    }
                    
                }
                else{
                    
                    strBillingCountry = ""
                    arrBillingPlaceHolderValues.remove(at: textField.tag)
                    arrBillingPlaceHolderValues.insert("Billing Country", at: textField.tag)
                }
                
            }
            else if(textField.tag == 6){
                
                if let billingEmail = textField.text?.trim() {
                    
                    strBillingEmail = billingEmail
                    
                    if (strBillingEmail.characters.count > 0)
                    {
                        arrBillingPlaceHolderValues.remove(at: textField.tag)
                        arrBillingPlaceHolderValues.insert(strBillingEmail, at: textField.tag)
                    }
                    else
                    {
                        arrBillingPlaceHolderValues.remove(at: textField.tag)
                        arrBillingPlaceHolderValues.insert("Billing Email", at: textField.tag)
                    }
                    
                }
                else{
                    
                    strBillingEmail = ""
                    arrBillingPlaceHolderValues.remove(at: textField.tag)
                    arrBillingPlaceHolderValues.insert("Billing Email", at: textField.tag)
                }
                
            }
            
            else if(textField.tag == 7){
                
                if let billingPhone = textField.text?.trim() {
                    
                    strBillingPhone = billingPhone
                    
                    if (strBillingPhone.characters.count > 0)
                    {
                        arrBillingPlaceHolderValues.remove(at: textField.tag)
                        arrBillingPlaceHolderValues.insert(strBillingPhone, at: textField.tag)
                    }
                    else
                    {
                        arrBillingPlaceHolderValues.remove(at: textField.tag)
                        arrBillingPlaceHolderValues.insert("Billing Telephone", at: textField.tag)
                    }
                    
                }
                else{
                    
                    strBillingPhone = ""
                    arrBillingPlaceHolderValues.remove(at: textField.tag)
                    arrBillingPlaceHolderValues.insert("Billing Telephone", at: textField.tag)
                }
                
            }
            
            print("arrBillingPlaceHolderValues: \(arrBillingPlaceHolderValues)")
            
        }
        else {
            
            if(textField.tag == 0){
                
                if let deliveryName = textField.text?.trim() {
                    
                    strDeliveryName = deliveryName
                    
                    if (strDeliveryName.characters.count > 0)
                    {
                        arrDeliveryPlaceHolderValues.remove(at: textField.tag)
                        arrDeliveryPlaceHolderValues.insert(strDeliveryName, at: textField.tag)
                    }
                    else
                    {
                        arrDeliveryPlaceHolderValues.remove(at: textField.tag)
                        arrDeliveryPlaceHolderValues.insert("Delivery Name", at: textField.tag)
                    }
                    
                }
                else{
                    
                    strDeliveryName = ""
                    arrDeliveryPlaceHolderValues.remove(at: textField.tag)
                    arrDeliveryPlaceHolderValues.insert("Delivery Name", at: textField.tag)
                }
                
            }
            else if(textField.tag == 1){
                
                if let deliveryAddress = textField.text?.trim() {
                    
                    strDeliveryAddress = deliveryAddress
                    
                    if (strDeliveryAddress.characters.count > 0)
                    {
                        arrDeliveryPlaceHolderValues.remove(at: textField.tag)
                        arrDeliveryPlaceHolderValues.insert(strDeliveryAddress, at: textField.tag)
                    }
                    else
                    {
                        arrDeliveryPlaceHolderValues.remove(at: textField.tag)
                        arrDeliveryPlaceHolderValues.insert("Delivery Address", at: textField.tag)
                    }
                    
                }
                else{
                    
                    strDeliveryAddress = ""
                    arrDeliveryPlaceHolderValues.remove(at: textField.tag)
                    arrDeliveryPlaceHolderValues.insert("Delivery Address", at: textField.tag)
                }
                
            }
            else if(textField.tag == 2){
                
                if let deliveryCity = textField.text?.trim() {
                    
                    strDeliveryCity = deliveryCity
                    
                    if (strDeliveryCity.characters.count > 0)
                    {
                        arrDeliveryPlaceHolderValues.remove(at: textField.tag)
                        arrDeliveryPlaceHolderValues.insert(strDeliveryCity, at: textField.tag)
                    }
                    else
                    {
                        arrDeliveryPlaceHolderValues.remove(at: textField.tag)
                        arrDeliveryPlaceHolderValues.insert("Delivery City", at: textField.tag)
                    }
                    
                }
                else{
                    
                    strDeliveryCity = ""
                    arrDeliveryPlaceHolderValues.remove(at: textField.tag)
                    arrDeliveryPlaceHolderValues.insert("Delivery City", at: textField.tag)
                }
                
            }
            else if(textField.tag == 3){
                
                if let deliveryState = textField.text?.trim() {
                    
                    strDeliveryState = deliveryState
                    
                    if (strDeliveryState.characters.count > 0)
                    {
                        arrDeliveryPlaceHolderValues.remove(at: textField.tag)
                        arrDeliveryPlaceHolderValues.insert(strDeliveryState, at: textField.tag)
                    }
                    else
                    {
                        arrDeliveryPlaceHolderValues.remove(at: textField.tag)
                        arrDeliveryPlaceHolderValues.insert("Delivery State", at: textField.tag)
                    }
                    
                }
                else{
                    
                    strDeliveryState = ""
                    arrDeliveryPlaceHolderValues.remove(at: textField.tag)
                    arrDeliveryPlaceHolderValues.insert("Delivery State", at: textField.tag)
                }
                
            }
                
            else if(textField.tag == 4){
                
                if let DeliveryPostal = textField.text?.trim() {
                    
                    strDeliveryPostal = DeliveryPostal
                    
                    if (strDeliveryPostal.characters.count > 0)
                    {
                        arrBillingPlaceHolderValues.remove(at: textField.tag)
                        arrBillingPlaceHolderValues.insert(strDeliveryPostal, at: textField.tag)
                    }
                    else
                    {
                        arrBillingPlaceHolderValues.remove(at: textField.tag)
                        arrBillingPlaceHolderValues.insert("Delivery Postal", at: textField.tag)
                    }
                    
                }
                else{
                    
                    strDeliveryPostal = ""
                    arrBillingPlaceHolderValues.remove(at: textField.tag)
                    arrBillingPlaceHolderValues.insert("Delivery Postal", at: textField.tag)
                }
                
            }
   
                
            else if(textField.tag == 5){
                
                if let deliveryCountry = textField.text?.trim() {
                    
                    strDeliveryCountry = deliveryCountry
                    
                    if (strDeliveryCountry.characters.count > 0)
                    {
                        arrDeliveryPlaceHolderValues.remove(at: textField.tag)
                        arrDeliveryPlaceHolderValues.insert(strDeliveryCountry, at: textField.tag)
                    }
                    else
                    {
                        arrDeliveryPlaceHolderValues.remove(at: textField.tag)
                        arrDeliveryPlaceHolderValues.insert("Delivery Country", at: textField.tag)
                    }
                    
                }
                else{
                    
                    strDeliveryCountry = ""
                    arrDeliveryPlaceHolderValues.remove(at: textField.tag)
                    arrDeliveryPlaceHolderValues.insert("Delivery Country", at: textField.tag)
                }
                
            }
            
            else if(textField.tag == 6){
                
                if let deliveryPhone = textField.text?.trim() {
                    
                    strDeliveryPhone = deliveryPhone
                    
                    if (strDeliveryPhone.characters.count > 0)
                    {
                        arrDeliveryPlaceHolderValues.remove(at: textField.tag)
                        arrDeliveryPlaceHolderValues.insert(strDeliveryPhone, at: textField.tag)
                    }
                    else
                    {
                        arrDeliveryPlaceHolderValues.remove(at: textField.tag)
                        arrDeliveryPlaceHolderValues.insert("Delivery Telephone", at: textField.tag)
                    }
                    
                }
                else{
                    
                    strDeliveryPhone = ""
                    arrDeliveryPlaceHolderValues.remove(at: textField.tag)
                    arrDeliveryPlaceHolderValues.insert("Delivery Telephone", at: textField.tag)
                }
                
            }
            
             print("arrDeliveryPlaceHolderValues: \(arrDeliveryPlaceHolderValues)")
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (isViewUp == true) {
            
            viewDown()
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    func viewUp() {
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            
            UIView.animate(withDuration: 0.5) {
                
                self.view.frame = CGRect(x: self.view.frame.origin.x, y: -130, width: self.view.frame.size.width, height: self.view.frame.size.height)
                
                self.isViewUp = true
            }
        }
            
        else {
            
            UIView.animate(withDuration: 0.5) {
                
                self.view.frame = CGRect(x: self.view.frame.origin.x, y: -110, width: self.view.frame.size.width, height: self.view.frame.size.height)
                
                self.isViewUp = true
            }
        }
        
    }
    
    func viewDown() {
        
        UIView.animate(withDuration: 0.5) {
            
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            
            self.isViewUp = false
        }
        
    }

    //MARK:- Function
    func indexPathForTextField(textField : UITextField) -> IndexPath {
        
        let textFieldPosition:CGPoint = textField.convert(CGPoint.zero, to:tblAddress)
        let indexPath = tblAddress.indexPathForRow(at: textFieldPosition)
        
        return indexPath!
    }
    
   //MARK:- Button Action
    
    func backBtnTap(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if isViewUp {
            viewDown()
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCheckBoxSaveInfoAction(_ sender: Any) {
        
        if isSaveBillingInfoChecked {
            
            self.isSaveBillingInfoChecked = false
            self.imgVwCheckBoxIcon.image = UIImage.init(named: "box_empty.png")
        }
        else {
            
            self.isSaveBillingInfoChecked = true
            self.imgVwCheckBoxIcon.image = UIImage.init(named: "box_tick.png")
        }
    }
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        
        if alert() {
            
            let dictionaryBillingInfo = [ "billingName" : strBillingName ,
                                   "billingAddress" : strBillingAddress,
                                   "billingCity" : strBillingCity,
                                   "billingState" : strBillingState,
                                   "billingPostal" : strBillingPostal,
                                   "billingCountry" : strBillingCountry,
                                   "billingEmail" : strBillingEmail,
                                   "billingPhone" : strBillingPhone,
                                   "deliveryName" : strDeliveryName,
                                   "deliveryAddress" : strDeliveryAddress,
                                   "deliveryCity" : strDeliveryCity,
                                   "deliveryState" : strDeliveryState,
                                   "deliveryPostal" : strDeliveryPostal,
                                   "deliveryCountry" : strDeliveryCountry,
                                   "deliveryPhone" : strDeliveryPhone,
                                   ] as [String : Any]
            
            // Storing the dictionary
            let objBillingInfo = ModelBillingInfo.init(infoDic: dictionaryBillingInfo as NSDictionary)
            let data = NSKeyedArchiver.archivedData(withRootObject: objBillingInfo)
            
            if GlobalUserDefaults.save(data as AnyObject, withKey: "BillingInfo"){
                
                print("saved to UserDefaults")
            }
            else{
                
                print("unable to save UserDefaults")
            }
            
            let paymentView = PaymentModeViewController(nibName: "PaymentModeViewController", bundle: nil)
            
            paymentView .acc_ID = "25050"  //"23059"
            paymentView.secret_KEY = "b644e58daa1109732c2912b01d791519" //"8ccdb92cb3d36e8533ec3413da337439"
            // paymentView.channel = 0
            paymentView.algorithm = "0" //Merchant has to configure the Algorithm 0 for md5, 1 for sha1, 2 for sha512
            paymentView.mode = "LIVE"
            
            paymentView.paymentAmtString = "1.00";
            paymentView.strSaleAmount = "1.00";
            
            paymentView.strCurrency = "INR";
            paymentView.strDisplayCurrency = "USD";
            
            //Reference no has to be configured
            paymentView.reference_no = "223";
            
            paymentView.strDescription = "Test Description";
            
            paymentView.strBillingName = objBillingInfo.strBillingName;
            paymentView.strBillingAddress = objBillingInfo.strBillingAddress;
            paymentView.strBillingCity = objBillingInfo.strBillingCity;
            paymentView.strBillingState = objBillingInfo.strBillingState;
            paymentView.strBillingPostal = objBillingInfo.strBillingPostal;
            paymentView.strBillingCountry = objBillingInfo.strBillingCountry;
            paymentView.strBillingEmail = objBillingInfo.strBillingEmail;
            paymentView.strBillingTelephone = objBillingInfo.strBillingPhone;
            
            // Non mandatory parameters
            paymentView.strDeliveryName = objBillingInfo.strDeliveryName;
            paymentView.strDeliveryAddress = objBillingInfo.strDeliveryAddress;
            paymentView.strDeliveryCity = objBillingInfo.strDeliveryCity;
            paymentView.strDeliveryState = objBillingInfo.strDeliveryState;
            paymentView.strDeliveryPostal = objBillingInfo.strDeliveryPostal;
            paymentView.strDeliveryCountry = objBillingInfo.strDeliveryCountry;
            paymentView.strDeliveryTelephone = objBillingInfo.strDeliveryPhone;
           
            self.navigationController!.pushViewController(paymentView, animated: true)

        }
    }
    
    //MARK:- Alert
    
    func alert() -> Bool {
        
        if (strBillingName.characters.count == 0) {
            
            displayError(withMessage: "Please enter Billing Name")
            return false
        }
        
        if (strBillingAddress.characters.count == 0) {
            
            displayError(withMessage: "Please enter Billing Address")
            return false
        }
        if (strBillingCity.characters.count == 0) {
            
            displayError(withMessage: "Please enter City")
            return false
        }
        if (strBillingState.characters.count == 0) {
            
            displayError(withMessage: "Please enter State")
            return false
        }
        if (strBillingPostal.characters.count == 0) {
            
            displayError(withMessage: "Please enter valid Billing Postal")
            return false
        }
        if (strBillingCountry.characters.count == 0) {
            
            displayError(withMessage: "Please enter Country")
            return false
        }
        if (strBillingEmail.characters.count == 0) {
            
            displayError(withMessage: "Please enter Billing e-mail")
            return false
        }
        
        if (isValidEmail(strBillingEmail) == false) {
            
            displayError(withMessage: "Please enter valid email")
            return false
        }
        if (strBillingPhone.characters.count == 0) {
            
            displayError(withMessage: "Please enter valid Phone Number")
            return false
        }
        
        if (strDeliveryName.characters.count == 0) {
            
            displayError(withMessage: "Please enter valid Delivery Name")
            return false
        }
        
        if (strDeliveryAddress.characters.count == 0) {
            
            displayError(withMessage: "Please enter Delivery Address")
            return false
        }
        if (strDeliveryCity.characters.count == 0) {
            
            displayError(withMessage: "Please enter City")
            return false
        }
        if (strDeliveryState.characters.count == 0) {
            
            displayError(withMessage: "Please enter State")
            return false
        }
        if (strDeliveryPostal.characters.count == 0) {
            
            displayError(withMessage: "Please enter valid Delivery Postal")
            return false
        }
        if (strDeliveryCountry.characters.count == 0) {
            
            displayError(withMessage: "Please enter Country")
            return false
        }
        if (strDeliveryPhone.characters.count == 0) {
            
            displayError(withMessage: "Please enter valid Phone Number")
            return false
        }
        
        return true
    }

    
    //MARK:-

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
