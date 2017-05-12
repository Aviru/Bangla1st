//
//  signUpVC.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 08/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "signUpVC.h"
#import "SignUpTableViewCell.h"
#import "SignUpWebService.h"
#import "LoginWebService.h"
#import "TermsAndConditionsVC.h"

#import "ModelCountryList.h"
#import "ModelUserTypeList.h"
#import "CMPopTipView.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


@interface signUpVC ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,CMPopTipViewDelegate>
{
   
    IBOutlet UIView *navBarContainerView;
    
    IBOutlet UITableView *tblSignUp;
    
    IBOutlet UIImageView *imgvwCheckboxicon;
    
    IBOutlet UIButton *btnCheckBtnOutlet;
    
    
    NSArray *arrCellIcon, *arrIcons ,*arrCountry, *arrUserType;
    NSMutableArray *arrPlaceHolder;
    
    NSString *strFullName, *strEmail, *strPassword, *strRePassword, *strDob, *strCountry, *strState, *strCity,*strGender, *strUserSubscriptionType, *strCountryId, *strUserTypeId;
    
    UITextField *globalTextField;
    UIDatePicker *datePickerView;
    UIToolbar *toolBar;
    BOOL isViewUp, isMaleBtnTap, isFemaleBtnTap, isCheckBoxSelected, isDropDownOpen, isCountryCellTap, isValidPassword, isPasswordShown;
    
    UIView *dropDownListView;
    UITableView *tableViewDropDown;
    CGRect DropDownFrame;
    int keyBoardHeight,keyBoardWidth;
    
    SignUpTableViewCell *countryDropDownCell, *UserTypeDropDownCell;

}

@end

@implementation signUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrCountry = [self.appDel.arrCountryList copy];
    
    arrPlaceHolder = [[NSMutableArray alloc]initWithObjects:@"Your Name",@"Email",@"Password",@"Re-enter Password",@"Date of birth",@"Country",@"State",@"City",@"", nil]; //@"User Type"
    
    arrCellIcon = [[NSArray alloc]initWithObjects:@"user.png",@"email_icon.png",@"password_key.png",@"password_key.png",@"calendar.png",@"country.png",@"location.png",@"location.png",@"", nil]; //@"subscription_icon.png"
   
    /*
    NSArray *fontFamilies = [UIFont familyNames];
    for (int i = 0; i < [fontFamilies count]; i++)
    {
        NSString *fontFamily = [fontFamilies objectAtIndex:i];
        NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
        NSLog (@"%@: %@", fontFamily, fontNames);
    }
     */
     
    
    UIFont *customFont = [UIFont fontWithName:@"BerlinSansFB-Reg" size:20];
    
    [self initWithParentView:navBarContainerView isTranslateToAutoResizingMaskNeeded:NO leftButton:YES rightButton:NO navigationTitle:@"Sign Up" navigationTitleTextAlignment:NSTextAlignmentCenter navigationTitleFontType:customFont leftImageName:@"back_arrow.png" leftLabelName:@" Back" rightImageName:nil rightLabelName:nil];
    
    [self.navBar.navBarLeftButtonOutlet addTarget:self action:@selector(backBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    
    /*
    NSCalendar * gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDate * currentDate = [NSDate date];
    NSDateComponents * comps = [[NSDateComponents alloc] init];
    [comps setYear: -18];
    NSDate * maxDate = [gregorian dateByAddingComponents: comps toDate: currentDate options: 0];
    [comps setYear: -100];
    NSDate * minDate = [gregorian dateByAddingComponents: comps toDate: currentDate options: 0];
     */
   
    datePickerView=[[UIDatePicker alloc] init];
    datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    datePickerView.maximumDate = [NSDate date];
    [datePickerView setDatePickerMode:UIDatePickerModeDate];
    [datePickerView addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done" style:UIBarButtonItemStyleDone
                                   target:self action:@selector(pressedDone:)];
    toolBar = [[UIToolbar alloc]initWithFrame:
               CGRectMake(0, self.view.frame.size.height-
                          datePickerView.frame.size.height-70, self.view.frame.size.width, 36)];
    [toolBar setBarStyle:UIBarStyleDefault];
    NSArray *toolbarItems = [NSArray arrayWithObjects:
                             doneButton,nil];
    [toolBar setItems:toolbarItems];
    
    strFullName = @"";
    strEmail = @"";
    strPassword = @"";
    strRePassword = @"";
    strDob = @"";
    strCountry = @"";
    strState = @"";
    strCity = @"";
    strGender = @"male";
    strUserSubscriptionType = @"";
    strCountryId = @"";
    strUserTypeId = @"";
    isMaleBtnTap = YES;
    isFemaleBtnTap = NO;
    
    [btnCheckBtnOutlet setSelected:NO];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    
    [self closeDropDownView];
    
    tableViewDropDown = nil;
    tableViewDropDown.dataSource = nil;
    tableViewDropDown.delegate = nil;
    
    tblSignUp = nil;
    tblSignUp.dataSource = nil;
    tblSignUp.delegate = nil;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark
#pragma mark Tableview delegates and Datasource
#pragma mark

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(scrollView == tblSignUp)
    {
        [self closeDropDownView];
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tblSignUp)
    {
         return arrPlaceHolder.count;
    }
    
    else
    {
        if (isCountryCellTap)
        {
            return arrCountry.count;
        }
        else
            return self.appDel.arrUserTypeList.count;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblSignUp)
    {
        return 60.0;
    }
    
    else
        return 35.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblSignUp)
    {
        if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 ||indexPath.row == 3 || indexPath.row == 4 ||indexPath.row == 6 || indexPath.row == 7)
        {
            SignUpTableViewCell *cell = (SignUpTableViewCell *)[tblSignUp dequeueReusableCellWithIdentifier:@"normalCell"];
            if (cell==nil)
            {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"SignUpTableViewCell" owner:self options:nil]objectAtIndex:0];
            }
            
            NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            [style setAlignment:NSTextAlignmentLeft];
            [style setLineBreakMode:NSLineBreakByWordWrapping];
            UIColor *colorRed = [UIColor colorWithRed:255.0/255.0 green:83.0/255.0 blue:31.0/255.0 alpha:1.0];
            
            UIFont *font1 = [UIFont systemFontOfSize:14.0];
            NSDictionary *dict2 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                                    NSFontAttributeName:font1,
                                    NSForegroundColorAttributeName : colorRed,
                                    NSParagraphStyleAttributeName:style};
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
            [attString appendAttributedString:[[NSAttributedString alloc] initWithString:arrPlaceHolder[indexPath.row] attributes:dict2]];
            
            cell.txtSignUpFields.attributedPlaceholder = attString;
            cell.txtSignUpFields.tag = indexPath.row;
            
            cell.imgVwTextFieldBorder.layer.borderColor = [UIColor grayColor].CGColor;
            cell.imgVwTextFieldBorder.layer.borderWidth = 1.0;
            cell.imgVwTextFieldBorder.layer.cornerRadius = 2.0;
            cell.txtSignUpFields.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
            
            cell.imgVwIconTextFields.image = [UIImage imageNamed:arrCellIcon[indexPath.row]];
            
            if (indexPath.row == 0)
            {
                cell.txtSignUpFields.autocapitalizationType = UITextAutocapitalizationTypeWords;
            }
            else
                cell.txtSignUpFields.autocapitalizationType = UITextAutocapitalizationTypeNone;
            
            if (indexPath.row == 2 ||indexPath.row == 3)
            {
                cell.txtSignUpFields.secureTextEntry = YES;
                
                cell.imgVwEyeIcon.hidden = NO;
                
                cell.btnShowPasswordOutlet.userInteractionEnabled = YES;
                
                [cell.btnShowPasswordOutlet addTarget:self action:@selector(btnHideUnhidePaswdTap:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                cell.imgVwEyeIcon.hidden = YES;
                cell.btnShowPasswordOutlet.userInteractionEnabled = NO;
                cell.txtSignUpFields.secureTextEntry = NO;
                
            }
            
            
            cell.txtSignUpFields.delegate = self;
            [cell.txtSignUpFields addTarget:self
                                     action:@selector(textFieldDidChange:)
                           forControlEvents:UIControlEventEditingChanged];
            
            return cell;
        }
        
        if (indexPath.row == 5 || indexPath.row == 9 )
        {
            SignUpTableViewCell *cell = (SignUpTableViewCell *)[tblSignUp dequeueReusableCellWithIdentifier:@"dropDownCell"];
            if (cell==nil)
            {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"SignUpTableViewCell" owner:self options:nil]objectAtIndex:1];
            }
            
            NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            [style setAlignment:NSTextAlignmentLeft];
            [style setLineBreakMode:NSLineBreakByWordWrapping];
            UIColor *colorRed = [UIColor colorWithRed:255.0/255.0 green:83.0/255.0 blue:31.0/255.0 alpha:1.0];
            
            UIFont *font1 = [UIFont systemFontOfSize:14.0];
            NSDictionary *dict2 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                                    NSFontAttributeName:font1,
                                    NSForegroundColorAttributeName : colorRed,
                                    NSParagraphStyleAttributeName:style};
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
            [attString appendAttributedString:[[NSAttributedString alloc] initWithString:arrPlaceHolder[indexPath.row] attributes:dict2]];
            
            cell.txtDropDown.attributedPlaceholder = attString;
            
            cell.txtDropDown.layer.borderColor = [UIColor grayColor].CGColor;
            cell.txtDropDown.layer.borderWidth = 1.0;
            cell.txtDropDown.layer.cornerRadius = 2.0;
            cell.txtDropDown.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
            
            cell.txtDropDown.tag = indexPath.row;
            cell.txtDropDown.delegate = self;
           
            cell.imgVwIconDropDown.image = [UIImage imageNamed:arrCellIcon[indexPath.row]];
            
            return cell;
        }
        
        else
        {
            SignUpTableViewCell *cell = (SignUpTableViewCell *)[tblSignUp dequeueReusableCellWithIdentifier:@"genderCell"];
            if (cell==nil)
            {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"SignUpTableViewCell" owner:self options:nil]objectAtIndex:2];
            }
            
            [cell.btnMaleOutlet addTarget:self action:@selector(btnMalePress:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnFemaleOutlet addTarget:self action:@selector(btnFemalePress:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
    }
    
    ///******DROP DOWN LISTING Table View*****
    
    else
    {
        UITableViewCell *cell;
        static NSString *cellIdentifier;
        
        if (isCountryCellTap)
        {
            cellIdentifier = @"CountryDropDownListCell";
            cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.textLabel.text = [arrCountry[indexPath.row] strCountryName];
        }
        else
        {
            cellIdentifier = @"UserTypeDropDownListCell";
            cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.textLabel.text = [self.appDel.arrUserTypeList [indexPath.row] strCategoryTitle];
        }
        
        UIFont *myFont = [ UIFont systemFontOfSize:14.0];
        
        cell.textLabel.font  = myFont;
        cell.textLabel.textColor = [UIColor grayColor];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblSignUp)
    {
    }
    
    ///****** DROP DOWN LISTING Table View*****
    
    else
    {
        if (isCountryCellTap)
        {
            strCountryId = [arrCountry[indexPath.row] strCountryCode];
            strCountry = [arrCountry[indexPath.row] strCountryName];
            [arrPlaceHolder removeObjectAtIndex:5];
            [arrPlaceHolder insertObject:strCountry atIndex:5];
            countryDropDownCell.txtDropDown.text = strCountry;
            
            isDropDownOpen = NO;
            [UIView animateWithDuration:0.5 animations:^{
                
                dropDownListView.frame = DropDownFrame;
                dropDownListView = nil;
                
                [UIView animateWithDuration:0.0f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    countryDropDownCell.imgVwDropDownArrow.transform = CGAffineTransformMakeRotation(M_PI - 3.14159);
                } completion:nil];
                
            }completion:nil];
        }
        else
        {
            strUserTypeId = [self.appDel.arrUserTypeList [indexPath.row] strCategoryID];
            strUserSubscriptionType = [self.appDel.arrUserTypeList [indexPath.row] strCategoryTitle];
            [arrPlaceHolder removeObjectAtIndex:9];
            [arrPlaceHolder insertObject:strUserSubscriptionType atIndex:9];
            UserTypeDropDownCell.txtDropDown.text = strUserSubscriptionType;
            
            isDropDownOpen = NO;
            [UIView animateWithDuration:0.5 animations:^{
                
                dropDownListView.frame = DropDownFrame;
                dropDownListView = nil;
                
                [UIView animateWithDuration:0.0f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    UserTypeDropDownCell.imgVwDropDownArrow.transform = CGAffineTransformMakeRotation(M_PI - 3.14159);
                } completion:nil];
                
            }completion:nil];
        }
    }
}

#pragma mark

#pragma mark
#pragma mark- Button Action
#pragma mark

-(void)backBtnPress:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnHideUnhidePaswdTap:(UIButton *)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblSignUp];
    NSIndexPath *indexPath = [tblSignUp indexPathForRowAtPoint:buttonPosition];
    SignUpTableViewCell *cell = (SignUpTableViewCell *)[tblSignUp cellForRowAtIndexPath:indexPath];
    
    if (isPasswordShown == NO)
    {
        isPasswordShown = YES;
        cell.imgVwEyeIcon.image = [UIImage imageNamed:@"password_hide_eye_icon.png"];
        [cell.txtSignUpFields setSecureTextEntry:NO];
    }
    else
    {
        isPasswordShown = NO;
        cell.imgVwEyeIcon.image = [UIImage imageNamed:@"eye_gray.png"];
        [cell.txtSignUpFields setSecureTextEntry:YES];
    }
}

-(void)btnFemalePress:(UIButton *)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblSignUp];
    NSIndexPath *indexPath = [tblSignUp indexPathForRowAtPoint:buttonPosition];
    SignUpTableViewCell *cell = (SignUpTableViewCell *)[tblSignUp cellForRowAtIndexPath:indexPath];
    isFemaleBtnTap = YES;
    
    if (isMaleBtnTap)
    {
        isMaleBtnTap = NO;
        cell.imgVwFemaleRadioIcon.image = [UIImage imageNamed:@"radio_128x128.png"];
        cell.imgVwMaleRadioIcon.image = [UIImage imageNamed:@"radio_lightgray_icon.png"];
        strGender = @"female";
    }
}

-(void)btnMalePress:(UIButton *)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblSignUp];
    NSIndexPath *indexPath = [tblSignUp indexPathForRowAtPoint:buttonPosition];
    SignUpTableViewCell *cell = (SignUpTableViewCell *)[tblSignUp cellForRowAtIndexPath:indexPath];
    isMaleBtnTap = YES;
        
    if (isFemaleBtnTap)
    {
        isFemaleBtnTap = NO;
        cell.imgVwFemaleRadioIcon.image = [UIImage imageNamed:@"radio_lightgray_icon.png"];
        cell.imgVwMaleRadioIcon.image = [UIImage imageNamed:@"radio_128x128.png"];
        strGender = @"male";
    }
}


- (IBAction)btnCheckBoxAction:(id)sender
{
    if ([btnCheckBtnOutlet isSelected])
    {
        isCheckBoxSelected = NO;
        [btnCheckBtnOutlet setSelected:NO];
        
        [imgvwCheckboxicon setImage:[UIImage imageNamed:@"checkbox_blank.png"]];
        
    }
    else
    {
        isCheckBoxSelected = YES;
        [btnCheckBtnOutlet setSelected:YES];
        
        [imgvwCheckboxicon setImage:[UIImage imageNamed:@"checkbox_tick.png"]];
    }
}

- (IBAction)btnTermsAndServicesAction:(id)sender
{
    TermsAndConditionsVC *termsVC=(TermsAndConditionsVC *)[MainStoryBoard instantiateViewControllerWithIdentifier:@"TermsAndConditionsVC"];
    [self.navigationController pushViewController:termsVC animated:YES];
}


- (IBAction)btnPrivacyPolicyAction:(id)sender
{
}

- (IBAction)btnSubmitAction:(id)sender
{
    if ([self alertChecking])
    {
         [self initializeAndStartActivityIndicator:self.view];
        
        NSDictionary *signUpDict = @{@"ApiKey":@"0a2b8d7f9243305f2a4700e1870f673a",@"username":strFullName,@"password":strPassword,@"email":strEmail,@"dob":strDob,@"country":strCountryId,@"state":strState,@"city":strCity,@"gender":strGender};
        //@"usercategory":strUserTypeId
        
        NSLog(@"signUpDict:%@",signUpDict);
        
        [[SignUpWebService service] callSignUpWebServiceWithDictParams:signUpDict success:^(id  _Nullable response, NSString * _Nullable strMsg) {
            
            if (response != nil)
            {
                NSDictionary *loginDict = [NSDictionary dictionaryWithDictionary:response[@"ResponseData"]];
                
                self.appDel.objModelUserInfo = [[ModelUserInfo alloc]initWithDictionary:loginDict];
                
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:loginDict];
                
                [GlobalUserDefaults saveObject:data withKey:USER_INFO];
                
                [self callNormalLoginWebService];
            }
            else
            {
                NSLog(@"%@", strMsg);
                
                UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"" message:strMsg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionOK=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [alertController dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                }];
                [alertController addAction:actionOK];
                [self presentViewController:alertController animated:YES completion:^{
                    
                }];
            }
        }
        failure:^(NSError * _Nullable error, NSString * _Nullable strMsg)
         {
             [self StopActivityIndicator:self.view];
             UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"" message:strMsg preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *actionOK=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                 [alertController dismissViewControllerAnimated:YES completion:^{
                     
                 }];
             }];
             [alertController addAction:actionOK];
             [self presentViewController:alertController animated:YES completion:^{
                 
             }];
         }];
    }
    
    
}

#pragma mark
#pragma mark Show Drop down
#pragma mark


-(void)showDropDown :(id)sender CountryDropDown:(BOOL)val
{
    NSIndexPath *indexPath;
    if (val)
    {
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblSignUp];
        indexPath = [tblSignUp indexPathForRowAtPoint:buttonPosition];
        countryDropDownCell = (SignUpTableViewCell *)[tblSignUp cellForRowAtIndexPath:indexPath];
    }
    else
    {
        CGPoint textFieldPosition = [sender convertPoint:CGPointZero toView:tblSignUp];
        indexPath = [tblSignUp indexPathForRowAtPoint:textFieldPosition];
        UserTypeDropDownCell = (SignUpTableViewCell *)[tblSignUp cellForRowAtIndexPath:indexPath];
    }
    
    CGRect rectOfCellInTableView = [tblSignUp rectForRowAtIndexPath: indexPath];
    CGRect rectOfCellInSuperview = [tblSignUp convertRect: rectOfCellInTableView toView: tblSignUp.superview];
    
    NSLog(@"Y of Cell is: %f", rectOfCellInSuperview.origin.y);
    
    [globalTextField resignFirstResponder];
    
    
    if (isDropDownOpen == NO)
    {
        isDropDownOpen = YES;
        
        if (val)
        {
            DropDownFrame = CGRectMake(CGRectGetMaxX(countryDropDownCell.imgVwIconDropDown.frame) + countryDropDownCell.txtDropDown.frame.origin.x +4,CGRectGetMaxY(rectOfCellInSuperview)  + countryDropDownCell.txtDropDown.frame.origin.y + 5 , countryDropDownCell.txtDropDown.frame.size.width, 0); //CGRectGetMaxY(countryDropDownCell.frame) +
        }
        else
        {
            DropDownFrame = CGRectMake(CGRectGetMaxX(UserTypeDropDownCell.imgVwIconDropDown.frame) + UserTypeDropDownCell.txtDropDown.frame.origin.x +5,CGRectGetMaxY(rectOfCellInSuperview)  + UserTypeDropDownCell.txtDropDown.frame.origin.y + 5, UserTypeDropDownCell.txtDropDown.frame.size.width, 0); //CGRectGetMaxY(tblSignUp.frame) + UserTypeDropDownCell.txtDropDown.frame.origin.y
        }
        
        /*
        
        if (IS_IPHONE_6_PLUS)
        {
            if (val)
            {
                DropDownFrame = CGRectMake(CGRectGetMaxX(countryDropDownCell.imgVwIconDropDown.frame) + countryDropDownCell.txtDropDown.frame.origin.x +4,rectOfCellInSuperview.origin.y  +countryDropDownCell.txtDropDown.frame.origin.y + countryDropDownCell.txtDropDown.frame.size.height , countryDropDownCell.txtDropDown.frame.size.width, 0); //CGRectGetMaxY(countryDropDownCell.frame) +
            }
            else
            {
                DropDownFrame = CGRectMake(CGRectGetMaxX(UserTypeDropDownCell.imgVwIconDropDown.frame) + UserTypeDropDownCell.txtDropDown.frame.origin.x +5,rectOfCellInSuperview.origin.y  + UserTypeDropDownCell.txtDropDown.frame.origin.y + UserTypeDropDownCell.txtDropDown.frame.size.height , UserTypeDropDownCell.txtDropDown.frame.size.width, 0); //CGRectGetMaxY(tblSignUp.frame) + UserTypeDropDownCell.txtDropDown.frame.origin.y
            }
            
        }
        else
        {
            
            if (val)
            {
                 DropDownFrame = CGRectMake(CGRectGetMaxX(countryDropDownCell.imgVwIconDropDown.frame) + countryDropDownCell.txtDropDown.frame.origin.x +4, CGRectGetMaxY(countryDropDownCell.frame) + countryDropDownCell.frame.size.height + 8 , countryDropDownCell.txtDropDown.frame.size.width, 0);
            }
            else
            {
               DropDownFrame = CGRectMake(CGRectGetMaxX(UserTypeDropDownCell.imgVwIconDropDown.frame) + UserTypeDropDownCell.txtDropDown.frame.origin.x, CGRectGetMaxY(tblSignUp.frame) + UserTypeDropDownCell.txtDropDown.frame.origin.y + 5 , UserTypeDropDownCell.txtDropDown.frame.size.width, 0);
                
            }
            
        }
        */
        
        
        dropDownListView = [[UIView alloc] initWithFrame:DropDownFrame];
        dropDownListView.backgroundColor = [UIColor clearColor];
        dropDownListView.layer.borderColor = [UIColor clearColor].CGColor;
        
        //dropDownListView.layer.borderWidth = 1.0;
        dropDownListView.layer.masksToBounds = YES;
        
        [self.view addSubview:dropDownListView];
        
        [UIView animateWithDuration:0.4 animations:^{
            
            if (val)
            {
                /*
                dropDownListView.frame = CGRectMake(DropDownFrame.origin.x, DropDownFrame.origin.y, DropDownFrame.size.width, [[UIScreen mainScreen]bounds].size.height-(keyBoardHeight + DropDownFrame.origin.y+2)); //UINDropDownCell.txtStudentInfo.frame.size.height
                tableViewDropDown = [[UITableView alloc]initWithFrame:CGRectMake(0,0, DropDownFrame.size.width, dropDownListView.frame.size.height)];
                 */
                
                dropDownListView.frame = CGRectMake(DropDownFrame.origin.x, DropDownFrame.origin.y, DropDownFrame.size.width, countryDropDownCell.txtDropDown.frame.size.height * 5);
                tableViewDropDown = [[UITableView alloc]initWithFrame:CGRectMake(0,0, DropDownFrame.size.width, arrCountry.count - 10)];
            }
            else
            {
                dropDownListView.frame = CGRectMake(DropDownFrame.origin.x, DropDownFrame.origin.y, DropDownFrame.size.width, UserTypeDropDownCell.txtDropDown.frame.size.height * 3);
                tableViewDropDown = [[UITableView alloc]initWithFrame:CGRectMake(0,0, DropDownFrame.size.width, UserTypeDropDownCell.txtDropDown.frame.size.height * self.appDel.arrUserTypeList.count)];
            }
            
            tableViewDropDown.dataSource = self;
            tableViewDropDown.delegate = self;
            tableViewDropDown.backgroundColor = [UIColor clearColor];
            [tableViewDropDown setShowsVerticalScrollIndicator:NO];
            [tableViewDropDown setScrollEnabled:YES];
            [tableViewDropDown setBounces:NO];
            [dropDownListView addSubview:tableViewDropDown];
            
            
            [UIView animateWithDuration:0.0f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                if (val)
                {
                    countryDropDownCell.imgVwDropDownArrow.transform = CGAffineTransformMakeRotation(M_PI);
                }
                else
                  UserTypeDropDownCell.imgVwDropDownArrow.transform = CGAffineTransformMakeRotation(M_PI);
                
            } completion:nil];
            
        }completion:nil];
    }
    else
    {
        isDropDownOpen = NO;
        [UIView animateWithDuration:0.5 animations:^{
            
            dropDownListView.frame = DropDownFrame;
            dropDownListView = nil;
            
            [UIView animateWithDuration:0.0f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                if (val)
                {
                    countryDropDownCell.imgVwDropDownArrow.transform = CGAffineTransformMakeRotation(M_PI - 3.14159);
                }
                else
                  UserTypeDropDownCell.imgVwDropDownArrow.transform = CGAffineTransformMakeRotation(M_PI - 3.14159);
                
            } completion:nil];
            
        }completion:nil];
    }


}

#pragma mark
#pragma mark - Close Drop Down
#pragma mark

-(void)closeDropDownView
{
    if (isDropDownOpen)
    {
        isDropDownOpen = NO;
        [UIView animateWithDuration:0.4 animations:^{
            
            dropDownListView.frame = DropDownFrame;
            dropDownListView = nil;
            
            [UIView animateWithDuration:0.0f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                if (isCountryCellTap)
                {
                    countryDropDownCell.imgVwDropDownArrow.transform = CGAffineTransformMakeRotation(M_PI - 3.14159);
                }
                else
                  UserTypeDropDownCell.imgVwDropDownArrow.transform = CGAffineTransformMakeRotation(M_PI - 3.14159);
                
            } completion:nil];
            
        }completion:nil];
    }
    
}

#pragma mark
#pragma mark Keyboard delegates
#pragma mark

- (void)keyboardWasShown:(NSNotification *)notification
{
    
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //Given size may not account for screen rotation
    keyBoardHeight = MIN(keyboardSize.height,keyboardSize.width);
    keyBoardWidth = MAX(keyboardSize.height,keyboardSize.width);
    
    /*
    if (globalTextField.tag == 5)
    {
        isDropDownOpen = NO;
        isCountryCellTap = YES;
        [self showDropDown:globalTextField CountryDropDown:YES];
    }
     */
    
    //your other code here..........
}

#pragma mark
#pragma mark - textfield delegate
#pragma mark

-(void)textFieldDidChange:(UITextField *)theTextField
{
   // NSLog( @"text changed: %@", theTextField.text);
    
    if (theTextField.tag==0)
    {
        strFullName=[theTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (strFullName.length > 0)
        {
            [arrPlaceHolder removeObjectAtIndex:theTextField.tag];
            [arrPlaceHolder insertObject:strFullName atIndex:theTextField.tag];
        }
        else
        {
            [arrPlaceHolder removeObjectAtIndex:theTextField.tag];
            [arrPlaceHolder insertObject:@"Your Name" atIndex:theTextField.tag];
        }
        
    }
    else if(theTextField.tag==1)
    {
        strEmail=[theTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (strEmail.length > 0)
        {
            [arrPlaceHolder removeObjectAtIndex:theTextField.tag];
            [arrPlaceHolder insertObject:strEmail atIndex:theTextField.tag];
        }
        else
        {
            [arrPlaceHolder removeObjectAtIndex:theTextField.tag];
            [arrPlaceHolder insertObject:@"Email" atIndex:theTextField.tag];
        }
    }
    else if (theTextField.tag==2)
    {
        strPassword=[theTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (strPassword.length > 0)
        {
            [self isContainUpperCase:strPassword];
            [self isContainLowerCase:strPassword];
            [self isContainSpecialCase:strPassword];
            [self isContainDigit:strPassword];
            [self isLengthMoreThan6:strPassword];

            if([self isContainUpperCase:strPassword] &&  [self isContainLowerCase:strPassword] &&    [self isContainSpecialCase:strPassword] &&    [self isContainDigit:strPassword] &&    [self isLengthMoreThan6:strPassword])
            {
                isValidPassword = YES;
            }
            else
            {
                isValidPassword = NO;
            }
            
            [arrPlaceHolder removeObjectAtIndex:theTextField.tag];
            [arrPlaceHolder insertObject:strPassword atIndex:theTextField.tag];
        }
        else
        {
            [arrPlaceHolder removeObjectAtIndex:theTextField.tag];
            [arrPlaceHolder insertObject:@"Password" atIndex:theTextField.tag];
        }
    }
    
    else if (theTextField.tag==3)
    {
        strRePassword=[theTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (strRePassword.length > 0)
        {
            [arrPlaceHolder removeObjectAtIndex:theTextField.tag];
            [arrPlaceHolder insertObject:strRePassword atIndex:theTextField.tag];
        }
        else
        {
            [arrPlaceHolder removeObjectAtIndex:theTextField.tag];
            [arrPlaceHolder insertObject:@"Re-enter Password" atIndex:theTextField.tag];
        }
    }
    
    else if (theTextField.tag==5)
    {
        strCountry=[theTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (strCountry.length > 0)
        {
            NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", strCountry];
            arrCountry = [self.appDel.arrCountryList filteredArrayUsingPredicate:resultPredicate];
            if (arrCountry.count)
            {
                [arrPlaceHolder removeObjectAtIndex:theTextField.tag];
                [arrPlaceHolder insertObject:strCountry atIndex:theTextField.tag];
                
                [tableViewDropDown reloadData];
                
                if (!isDropDownOpen) {
                    [self showDropDown:globalTextField CountryDropDown:YES];
                }
            }
            else
            {
                [arrPlaceHolder removeObjectAtIndex:theTextField.tag];
                [arrPlaceHolder insertObject:@"Country" atIndex:theTextField.tag];
                [self closeDropDownView];
            }
        }
        else
        {
            [arrPlaceHolder removeObjectAtIndex:theTextField.tag];
            [arrPlaceHolder insertObject:@"Country" atIndex:theTextField.tag];
            [self closeDropDownView];
        }
    }
    
    else if (theTextField.tag==6)
    {
        strState=[theTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (strState.length > 0)
        {
            [arrPlaceHolder removeObjectAtIndex:theTextField.tag];
            [arrPlaceHolder insertObject:strState atIndex:theTextField.tag];
        }
        else
        {
            [arrPlaceHolder removeObjectAtIndex:theTextField.tag];
            [arrPlaceHolder insertObject:@"State" atIndex:theTextField.tag];
        }
    }
    
    else if (theTextField.tag==7)
    {
        strCity=[theTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (strCity.length > 0)
        {
            [arrPlaceHolder removeObjectAtIndex:theTextField.tag];
            [arrPlaceHolder insertObject:strCity atIndex:theTextField.tag];
        }
        else
        {
            [arrPlaceHolder removeObjectAtIndex:theTextField.tag];
            [arrPlaceHolder insertObject:@"City" atIndex:theTextField.tag];
        }
    }
    
    NSLog(@"PlaceHolder Array:%@",arrPlaceHolder);
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    globalTextField = textField;
    
    if (globalTextField.tag == 2)
    {
        
        UIColor *backgroundColor = [UIColor colorWithRed:255.0/255.0 green:83.0/255.0 blue:31.0/255.0 alpha:1.0];
        UIColor *textColor = [UIColor whiteColor];
        
        CMPopTipView *popTipView;
        
        popTipView = [[CMPopTipView alloc] initWithMessage:@"Password length must be at least 6 character.\nPassword must conatin at least one lower case letter, one upper case letter, one digit and one special character"];
        popTipView.delegate = self;
        popTipView.backgroundColor = backgroundColor;
        popTipView.textColor = textColor;
        popTipView.animation = arc4random() % 2;
        popTipView.has3DStyle = (BOOL)(arc4random() % 2);
        popTipView.dismissTapAnywhere = YES;
        [popTipView presentPointingAtView:globalTextField inView:self.view animated:YES];
    }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (globalTextField.tag == 4)
    {
        globalTextField.inputView = datePickerView;
        globalTextField.inputAccessoryView = toolBar;
    }
    if (globalTextField.tag == 5)
    {
        //isDropDownOpen = NO;
        isCountryCellTap = YES;
        [self showDropDown:globalTextField CountryDropDown:YES];
    }
    
    else if(globalTextField.tag == 9)
    {
        isCountryCellTap = NO;
        [self showDropDown:globalTextField CountryDropDown:NO];
    }
    
    else
       [self closeDropDownView];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self closeDropDownView];
    
    [textField resignFirstResponder];
    return YES;
}

-(void)viewUp
{
    if (IS_IPHONE_4) {
        
        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame=CGRectMake(self.view.frame.origin.x,-100, self.view.frame.size.width, self.view.frame.size.height);
            isViewUp=YES;
        }];
    }
    else
        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame=CGRectMake(self.view.frame.origin.x,-80, self.view.frame.size.width, self.view.frame.size.height);
            isViewUp=YES;
        }];
    
}

-(void)viewDown
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        isViewUp=NO;
    }];
}

#pragma mark
#pragma mark- Toolbar Button Action
#pragma mark

-(void)pressedDone:(id)sender
{
    [self.view endEditing:YES];
    strDob = [self timeformatSet:[datePickerView date]];
    
    [arrPlaceHolder removeObjectAtIndex:globalTextField.tag];
    [arrPlaceHolder insertObject:strDob atIndex:globalTextField.tag];
    
    globalTextField.text = strDob;
}

#pragma mark-
#pragma mark - date picker change value not required right now
#pragma mark-

- (void)onDatePickerValueChanged:(UIDatePicker *)datePicker
{
    NSLog(@"DateSelect=%@",[datePicker date]);
    
}

#pragma mark-
#pragma set mark - dateformater
#pragma mark-

-(NSString*)timeformatSet:(NSDate*)date1
{
    NSString *strDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSLog(@"Current Date: %@", [formatter stringFromDate:date1]);
    strDate=[formatter stringFromDate:date1];
    return strDate;
}

#pragma mark
#pragma mark CMPopTipView Delegate
#pragma mark


- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView
{
    
}

#pragma mark
#pragma mark Alert Checking
#pragma mark

-(BOOL)alertChecking
{
    if (strFullName.length == 0)
    {
        [self displayErrorWithMessage:@"Please enter your Full Name"];
        return NO;
    }
    
    if (strEmail.length == 0)
    {
        [self displayErrorWithMessage:@"Please enter your email address"];
        return NO;
    }
    if (![self isValidEmail:strEmail])
    {
        [self displayErrorWithMessage:@"Please enter a valid email id!"];
        return NO;
    }
    
    if (strPassword.length == 0)
    {
        [self displayErrorWithMessage:@"Please enter password"];
        return NO;
    }
    
    if (isValidPassword == NO)
    {
        [self displayErrorWithMessage:@"Please enter valid password"];
        return NO;
    }
    
    if (strRePassword.length == 0)
    {
        [self displayErrorWithMessage:@"Please re-enter password"];
        return NO;
    }
    
    if (![strRePassword isEqualToString:strPassword])
    {
        [self displayErrorWithMessage:@"Re-enter Password mismatch"];
        return NO;
    }
    
    if (strDob.length == 0)
    {
        [self displayErrorWithMessage:@"Please enter your date of birth"];
        return NO;
    }
    
    if (strCountry.length == 0)
    {
        [self displayErrorWithMessage:@"Please select your country"];
        return NO;
    }
    
    if (strState.length == 0)
    {
        [self displayErrorWithMessage:@"Please enter State"];
        return NO;
    }
    
    if (strCity.length == 0)
    {
        [self displayErrorWithMessage:@"Please enter City"];
        return NO;
    }
    
    if (strUserSubscriptionType.length == 0)
    {
        [self displayErrorWithMessage:@"Please select subscription type"];
        return NO;
    }
    
    return YES;
}

#pragma mark
#pragma mark - Call Login Webservice
#pragma mark

-(void)callNormalLoginWebService
{
    NSString *strDeviceToken;
    
#if TARGET_IPHONE_SIMULATOR
    // Simulator
    strDeviceToken = @"fe3c1c39fb267847300fd9bd5fb30fc3df6a22c5d00f59743c138bfe15429d48";
#else
    //TODO: DEVICE TOKEN NEEDS TO BE CHANGED
    // iPhones
    //strDeviceToken =   [GlobalUserDefaults getObjectWithKey:DEVICETOKEN];
    strDeviceToken = @"fe3c1c39fb267847300fd9bd5fb30fc3df6a22c5d00f59743c138bfe15429d48";
#endif
    
    NSDictionary *LoginDict = @{@"ApiKey":@"0a2b8d7f9243305f2a4700e1870f673a",@"username":self.appDel.objModelUserInfo.strUserEmail,@"password":strPassword,@"deviceToken":strDeviceToken,@"loginType":@"normal"};
    
    [[LoginWebService service] callNormalLoginWebServiceWithDictParams:LoginDict success:^(id  _Nullable response, NSString * _Nullable strMsg) {
        
        [self StopActivityIndicator:self.view];
        
        if (response != nil)
        {
            NSDictionary *loginDict = [NSDictionary dictionaryWithDictionary:response[@"ResponseData"]];
            
            self.appDel.objModelUserInfo = [[ModelUserInfo alloc]initWithDictionary:loginDict];
            
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:loginDict];
            
            [GlobalUserDefaults saveObject:data withKey:USER_INFO];
            
            NSString *imgURL = self.appDel.objModelUserInfo.strUserProfileImageUrl;
            
            if (![self isEmpty:imgURL])
            {
                __block UIImage *image;
                NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:imgURL] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
                    [self StopActivityIndicator:self.view];
                    
                    if (!error)
                    {
                        if (data)
                        {
                            image = [UIImage imageWithData:data scale:0.5];
                            if (image)
                            {
                                
                                NSData *imgData = UIImageJPEGRepresentation(image, 0.4);
                                
                                [GlobalUserDefaults saveObject:imgData withKey:PROFILE_IMAGE];
                                
                            }
                        }
                    }
                    else
                    {
                        NSLog(@"error in profile pic download:%@",error.localizedDescription);
                    }
                    
                    
                }];
                
                [task resume];
            }
            else
            {
                UIImage *img = [UIImage imageNamed:@"avatar.png"];
                NSData *imgData = UIImageJPEGRepresentation(img, 0.4);
                [GlobalUserDefaults saveObject:imgData withKey:PROFILE_IMAGE];
            }
            
            
            [GlobalUserDefaults saveObject:@"YES" withKey:ISLOGGEDIN];
            
            // TODO: Move this to where you establish a user session
            [self logUser];
            
            
            [self performSegueWithIdentifier:@"segueToHome" sender:self];
        }
        else
        {
            NSLog(@"%@", strMsg);
        }
        
    } failure:^(NSError * _Nullable error, NSString * _Nullable strMsg) {
        
        [self StopActivityIndicator:self.view];
        
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"" message:strMsg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOK=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:^{
                
            }];
        }];
        [alertController addAction:actionOK];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
        
    }];
}

#pragma mark
#pragma mark - Crashlytics
#pragma mark

- (void) logUser
{
    //Use the current user's information
    // You can call any combination of these three methods
    [CrashlyticsKit setUserIdentifier:self.appDel.objModelUserInfo.strUserId];
    [CrashlyticsKit setUserEmail:self.appDel.objModelUserInfo.strUserEmail];
    [CrashlyticsKit setUserName:self.appDel.objModelUserInfo.strUserName];
}
#pragma mark

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
