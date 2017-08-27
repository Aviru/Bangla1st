//
//  EditProfileVC.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 28/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "EditProfileVC.h"
#import "EditProfileTableViewCell.h"

#import "ModelCountryList.h"
#import "ModelUserInfo.h"
#import "EditProfileWebService.h"
#import "ChangePasswordVC.h"

@interface EditProfileVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IBOutlet UITableView *tblEditprofile;
    IBOutlet UIView *navBarContainerVw;
    IBOutlet UIImageView *imgVwProfilePic;
    IBOutlet UIView *containerView;
    IBOutlet UIImageView *imgVwCameraIcon;
    
    
    UITextField *globalTextField;
    UIDatePicker *datePickerView;
    UIToolbar *toolBar;
    UIView *dropDownListView;
    UITableView *tableViewDropDown;
    UIImage *userImage;
    CGRect DropDownFrame;
    
    NSMutableArray *arrValuesAndPlaceHolder;
    UIImage *profileImage;
    BOOL isMaleBtnTap, isFemaleBtnTap, isDropDownOpen, isViewUp;
    NSString *strGender, *strCountry, *strCountryId, *strFullName, *strEmail, *strDob;
    NSArray *arrCountry;
    
    EditProfileTableViewCell *countryDropDownCell;
    ModelUserInfo *objModeluser;
}

@end

@implementation EditProfileVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIFont *customFont = [UIFont fontWithName:@"BerlinSansFB-Reg" size:20];
    
    [self initWithParentView:navBarContainerVw isTranslateToAutoResizingMaskNeeded:NO leftButton:YES rightButton:NO navigationTitle:@"Edit Profile" navigationTitleTextAlignment:NSTextAlignmentCenter navigationTitleFontType:customFont leftImageName:@"back_arrow.png" leftLabelName:@" Back" rightImageName:nil rightLabelName:nil];
    
    [self.navBar.navBarLeftButtonOutlet addTarget:self action:@selector(backBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    
    imgVwProfilePic.layer.cornerRadius = [[UIScreen mainScreen]bounds].size.width/2 * .35;
    
    imgVwProfilePic.clipsToBounds = YES;
    
    imgVwProfilePic.layer.borderColor = [UIColor colorWithRed:255.0/255.0 green:83.0/255.0 blue:31.0/255.0 alpha:1.0].CGColor;
    imgVwProfilePic.layer.borderWidth = 1.0;
    
    imgVwCameraIcon.layer.cornerRadius = [[UIScreen mainScreen]bounds].size.width/2 *.3 *.35;
    
    imgVwCameraIcon.clipsToBounds = YES;
    
    imgVwCameraIcon.layer.borderColor = [UIColor colorWithRed:255.0/255.0 green:83.0/255.0 blue:31.0/255.0 alpha:1.0].CGColor;
    imgVwCameraIcon.layer.borderWidth = 1.0;
    
    [containerView.layer setCornerRadius:2.0f];
    
    // border
    [containerView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [containerView.layer setBorderWidth:0.5f];
    
    // drop shadow
    [containerView.layer setShadowColor:[UIColor blackColor].CGColor];
    [containerView.layer setShadowOpacity:0.4];
    [containerView.layer setShadowRadius:1.0];
    [containerView.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
    
    arrCountry = [self.appDel.arrCountryList copy];
    
    objModeluser = self.appDel.objModelUserInfo;
    
    imgVwProfilePic.image = [UIImage imageWithData:[GlobalUserDefaults getObjectWithKey:PROFILE_IMAGE]];
    userImage = imgVwProfilePic.image;
    
   // NSString *strGenderType = ([self isEmpty:objModeluser.strUserSex])?@"male":objModeluser.strUserSex;
    
    NSString *strCountryCode;
    NSArray *filtered = [self.appDel.arrCountryList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.strCountryName matches %@", objModeluser.strUserCountry]]; //contains[cd]
    
    if (filtered.count > 0)
    {
        ModelCountryList *item = [filtered objectAtIndex:0];
        strCountryCode = item.strCountryCode;
    }

    
    strFullName = objModeluser.strUserName;
    strEmail = ([self isEmpty:objModeluser.strUserEmail])?@"Email":objModeluser.strUserEmail;
    strDob = ([self isEmpty:objModeluser.strUserDob])?@"Date Of Birth":objModeluser.strUserDob;
    strCountry = ([self isEmpty:objModeluser.strUserCountry])?@"Country":objModeluser.strUserCountry;
    strCountryId = ([self isEmpty:objModeluser.strUserCountry])?@"":strCountryCode;
    
    isMaleBtnTap = ([([self isEmpty:objModeluser.strUserSex])?@"male":objModeluser.strUserSex isEqualToString:@"male"])?YES:NO;
    isFemaleBtnTap = ([([self isEmpty:objModeluser.strUserSex])?NO:objModeluser.strUserSex isEqualToString:@"female"])?YES:NO; //([strGenderType isEqualToString:@"female"])?YES:NO;
    
    strGender = isMaleBtnTap?@"male":@"female";
    
     arrValuesAndPlaceHolder = [[NSMutableArray alloc]initWithObjects:strFullName,strEmail,strDob,strCountry,@"", nil];
    
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
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark
#pragma mark Tableview delegates and Datasource
#pragma mark
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tblEditprofile)
    {
         return arrValuesAndPlaceHolder.count;
    }
    
    else
    {
        return arrCountry.count;
    }
    
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblEditprofile)
    {
        return 60.0;
    }
    
    else
    {
        return 35.0;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblEditprofile)
    {
        if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3)
        {
            EditProfileTableViewCell *cell = (EditProfileTableViewCell *)[tblEditprofile dequeueReusableCellWithIdentifier:@"editProfileInfoCell"];
            if (cell==nil)
            {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"EditProfileTableViewCell" owner:self options:nil]objectAtIndex:0];
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
            [attString appendAttributedString:[[NSAttributedString alloc] initWithString:arrValuesAndPlaceHolder[indexPath.row] attributes:dict2]];
            
            cell.txtEditprofileInfo.attributedPlaceholder = attString;
            cell.txtEditprofileInfo.tag = indexPath.row;
            
            cell.txtEditprofileInfo.delegate = self;
            cell.txtEditprofileInfo.autocorrectionType = UITextAutocorrectionTypeNo;
            [cell.txtEditprofileInfo addTarget:self
                                        action:@selector(textFieldDidChange:)
                              forControlEvents:UIControlEventEditingChanged];
            
            cell.txtEditprofileInfo.layer.borderColor = [UIColor grayColor].CGColor;
            cell.txtEditprofileInfo.layer.borderWidth = 1.0;
            cell.txtEditprofileInfo.layer.cornerRadius = 2.0;
            cell.txtEditprofileInfo.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
            
            if (indexPath.row == 0)
            {
                cell.txtEditprofileInfo.autocapitalizationType = UITextAutocapitalizationTypeWords;
            }
            
            if (indexPath.row == 1)
            {
                cell.txtEditprofileInfo.keyboardType = UIKeyboardTypeEmailAddress;
            }
            
            if (indexPath.row == 3)
            {
                cell.imgVwDropDownIcon.hidden = NO;
            }
            
            return cell;
        }
        
        else
        {
            EditProfileTableViewCell *cell = (EditProfileTableViewCell *)[tblEditprofile dequeueReusableCellWithIdentifier:@"editGenderCell"];
            if (cell==nil)
            {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"EditProfileTableViewCell" owner:self options:nil]objectAtIndex:1];
            }
            
            if (isMaleBtnTap)
            {
                cell.imgVwFemaleRadioIcon.image = [UIImage imageNamed:@"radio_lightgray_icon.png"];
                cell.imgVwMaleRadioIcon.image = [UIImage imageNamed:@"radio_128x128.png"];
                strGender = @"male";
            }
            else
            {
                cell.imgVwFemaleRadioIcon.image = [UIImage imageNamed:@"radio_128x128.png"];
                cell.imgVwMaleRadioIcon.image = [UIImage imageNamed:@"radio_lightgray_icon.png"];
                strGender = @"female";
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
        
        cellIdentifier = @"CountryDropDownListCell";
        cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.text = [arrCountry[indexPath.row] strCountryName];
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
    
    if (tableView == tblEditprofile)
    {
    }
    
    ///****** DROP DOWN LISTING Table View*****
    
    else
    {
        strCountryId = [arrCountry[indexPath.row] strCountryCode];
        strCountry = [arrCountry[indexPath.row] strCountryName];
        [arrValuesAndPlaceHolder removeObjectAtIndex:3];
        [arrValuesAndPlaceHolder insertObject:strCountry atIndex:3];
        countryDropDownCell.txtEditprofileInfo.text = strCountry;
        
        isDropDownOpen = NO;
        [UIView animateWithDuration:0.5 animations:^{
            
            dropDownListView.frame = DropDownFrame;
            dropDownListView = nil;
            
            [UIView animateWithDuration:0.0f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                countryDropDownCell.imgVwDropDownIcon.transform = CGAffineTransformMakeRotation(M_PI - 3.14159);
            } completion:nil];
            
        }completion:nil];
    }

}

#pragma mark
#pragma mark Show Drop down
#pragma mark


-(void)showDropDown :(id)sender
{
     NSIndexPath *indexPath;
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblEditprofile];
    indexPath = [tblEditprofile indexPathForRowAtPoint:buttonPosition];
    countryDropDownCell = (EditProfileTableViewCell *)[tblEditprofile cellForRowAtIndexPath:indexPath];
    
    CGRect rectOfCellInTableView = [tblEditprofile rectForRowAtIndexPath: indexPath];
    CGRect rectOfCellInSuperview = [tblEditprofile convertRect: rectOfCellInTableView toView:tblEditprofile.superview.superview];
    
    NSLog(@"Y of Cell is: %f", rectOfCellInSuperview.origin.y);
    
    
    if (isDropDownOpen == NO)
    {
        isDropDownOpen = YES;
       // DropDownFrame = CGRectMake(CGRectGetMaxX(countryDropDownCell.imgVwDropDownIcon.frame) + countryDropDownCell.txtEditprofileInfo.frame.origin.x +4,CGRectGetMaxY(rectOfCellInSuperview) + countryDropDownCell.txtEditprofileInfo.frame.origin.y + 5 , countryDropDownCell.txtEditprofileInfo.frame.size.width, 0);
        
        //countryDropDownCell.txtEditprofileInfo.frame.origin.x + 10
        
        DropDownFrame = CGRectMake(countryDropDownCell.contentView.frame.size.width - countryDropDownCell.txtEditprofileInfo.frame.size.width, CGRectGetMaxY(rectOfCellInSuperview)-5, countryDropDownCell.txtEditprofileInfo.frame.size.width, 0);
        
        dropDownListView = [[UIView alloc] initWithFrame:DropDownFrame];
        dropDownListView.backgroundColor = [UIColor lightGrayColor];
        dropDownListView.layer.borderColor = [UIColor clearColor].CGColor;
        
        //dropDownListView.layer.borderWidth = 1.0;
        dropDownListView.layer.masksToBounds = YES;
        
        [self.view addSubview:dropDownListView];
        
        [UIView animateWithDuration:0.4 animations:^{
            dropDownListView.frame = CGRectMake(DropDownFrame.origin.x, DropDownFrame.origin.y, DropDownFrame.size.width, countryDropDownCell.txtEditprofileInfo.frame.size.height * 4);
            tableViewDropDown = [[UITableView alloc]initWithFrame:CGRectMake(0,0, DropDownFrame.size.width, arrCountry.count - 15)];
            tableViewDropDown.dataSource = self;
            tableViewDropDown.delegate = self;
            tableViewDropDown.backgroundColor = [UIColor clearColor];
            [tableViewDropDown setShowsVerticalScrollIndicator:NO];
            [tableViewDropDown setScrollEnabled:YES];
            [tableViewDropDown setBounces:NO];
            [dropDownListView addSubview:tableViewDropDown];
            
            
            [UIView animateWithDuration:0.0f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                countryDropDownCell.imgVwDropDownIcon.transform = CGAffineTransformMakeRotation(M_PI);
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
                countryDropDownCell.imgVwDropDownIcon.transform = CGAffineTransformMakeRotation(M_PI - 3.14159);
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
                countryDropDownCell.imgVwDropDownIcon.transform = CGAffineTransformMakeRotation(M_PI - 3.14159);
            } completion:nil];
            
        }completion:nil];
    }
    
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
#pragma mark - textfield delegate
#pragma mark

-(void)textFieldDidChange:(UITextField *)theTextField
{
    if (theTextField.tag==0)
    {
        strFullName=[theTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (strFullName.length > 0)
        {
            [arrValuesAndPlaceHolder removeObjectAtIndex:theTextField.tag];
            [arrValuesAndPlaceHolder insertObject:strFullName atIndex:theTextField.tag];
        }
        else
        {
            [arrValuesAndPlaceHolder removeObjectAtIndex:theTextField.tag];
            [arrValuesAndPlaceHolder insertObject:objModeluser.strUserName atIndex:theTextField.tag];
            strFullName = objModeluser.strUserName;
        }
        
    }
    else if(theTextField.tag==1)
    {
        strEmail=[theTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (strEmail.length > 0)
        {
            [arrValuesAndPlaceHolder removeObjectAtIndex:theTextField.tag];
            [arrValuesAndPlaceHolder insertObject:strEmail atIndex:theTextField.tag];
        }
        else
        {
            [arrValuesAndPlaceHolder removeObjectAtIndex:theTextField.tag];
            [arrValuesAndPlaceHolder insertObject:([self isEmpty:objModeluser.strUserEmail])?@"Email":objModeluser.strUserEmail atIndex:theTextField.tag];
            strEmail = ([self isEmpty:objModeluser.strUserEmail])?@"Email":objModeluser.strUserEmail;
        }
    }
    NSLog(@"PlaceHolder Array:%@",arrValuesAndPlaceHolder);
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    globalTextField = textField;
    
    if (globalTextField.tag == 2)
    {
        
        if (isViewUp) {
            
        }
        else
            [self viewUp];
        
        
        globalTextField.inputView = datePickerView;
        globalTextField.inputAccessoryView = toolBar;
        
    }
    if (globalTextField.tag == 3)
    {
        [self.view endEditing:YES];
        
        /*
        if (datePickerView.hidden == NO)
        {
            datePickerView.hidden = YES;
            globalTextField.inputView = nil;
            [globalTextField reloadInputViews];
        }
         */
         [globalTextField resignFirstResponder];
        
        [self showDropDown:globalTextField];
    }
    else
        [self closeDropDownView];
}


/*
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (isViewUp)
    {
        [self viewDown];
    }
    
    [textField resignFirstResponder];
    return YES;
}
 */


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self closeDropDownView];
    
    if (isViewUp)
    {
        [self viewDown];
    }
    
    [textField resignFirstResponder];
    return YES;
}


-(void)viewUp
{
    if (IS_IPHONE_4) {
        
        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame=CGRectMake(self.view.frame.origin.x,-80, self.view.frame.size.width, self.view.frame.size.height);
            isViewUp=YES;
        }];
    }
    else
        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame=CGRectMake(self.view.frame.origin.x,-30, self.view.frame.size.width, self.view.frame.size.height);
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
    
    [arrValuesAndPlaceHolder removeObjectAtIndex:globalTextField.tag];
    [arrValuesAndPlaceHolder insertObject:strDob atIndex:globalTextField.tag];
    
    globalTextField.text = strDob;
    
    if (isViewUp)
    {
        [self viewDown];
    }
}

#pragma mark
#pragma mark Button Action
#pragma mark

-(void)backBtnTap:(UIButton *)sender
{
    [self closeDropDownView];
    
    tableViewDropDown = nil;
    tableViewDropDown.dataSource = nil;
    tableViewDropDown.delegate = nil;
    
    tblEditprofile = nil;
    tblEditprofile.dataSource = nil;
    tblEditprofile.delegate = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnMalePress:(UIButton *)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblEditprofile];
    NSIndexPath *indexPath = [tblEditprofile indexPathForRowAtPoint:buttonPosition];
    EditProfileTableViewCell *cell = (EditProfileTableViewCell *)[tblEditprofile cellForRowAtIndexPath:indexPath];
    isMaleBtnTap = YES;
    
    if (isFemaleBtnTap)
    {
        isFemaleBtnTap = NO;
        cell.imgVwFemaleRadioIcon.image = [UIImage imageNamed:@"radio_lightgray_icon.png"];
        cell.imgVwMaleRadioIcon.image = [UIImage imageNamed:@"radio_128x128.png"];
        strGender = @"male";
    }
}


-(void)btnFemalePress:(UIButton *)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblEditprofile];
    NSIndexPath *indexPath = [tblEditprofile indexPathForRowAtPoint:buttonPosition];
    EditProfileTableViewCell *cell = (EditProfileTableViewCell *)[tblEditprofile cellForRowAtIndexPath:indexPath];
    isFemaleBtnTap = YES;
    
    if (isMaleBtnTap)
    {
        isMaleBtnTap = NO;
        cell.imgVwFemaleRadioIcon.image = [UIImage imageNamed:@"radio_128x128.png"];
        cell.imgVwMaleRadioIcon.image = [UIImage imageNamed:@"radio_lightgray_icon.png"];
        strGender = @"female";
    }
}

- (IBAction)btnImageCaptureAction:(id)sender
{
    [self setImageFromCamera];
}


- (IBAction)btnChangePasswordAction:(id)sender
{
   // [self performSegueWithIdentifier: @"segueToChangePassword" sender: self];
    
    ChangePasswordVC *changePswdVc=(ChangePasswordVC *)[MainStoryBoard instantiateViewControllerWithIdentifier:@"ChangePasswordVC"];
    
    /*
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame= changePswdVc.view.bounds;
    changePswdVc.view.backgroundColor = [UIColor clearColor];
    [changePswdVc.view insertSubview:visualEffectView atIndex:0];
     */
    
    changePswdVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [self presentViewController:changePswdVc animated:YES completion:nil];
}


- (IBAction)btnCancelAction:(id)sender
{
    arrValuesAndPlaceHolder = [[NSMutableArray alloc]initWithObjects:objModeluser.strUserName,([self isEmpty:objModeluser.strUserEmail])?@"Email":objModeluser.strUserEmail,([self isEmpty:objModeluser.strUserDob])?@"Date Of Birth":objModeluser.strUserDob,([self isEmpty:objModeluser.strUserCountry])?@"Country":objModeluser.strUserCountry,@"", nil];
    
    NSIndexPath *indx0 = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *indx1 = [NSIndexPath indexPathForRow:1 inSection:0];
    NSIndexPath *indx2 = [NSIndexPath indexPathForRow:2 inSection:0];
    NSIndexPath *indx3 = [NSIndexPath indexPathForRow:3 inSection:0];

    [tblEditprofile reloadRowsAtIndexPaths:@[indx0,indx1,indx2,indx3] withRowAnimation:UITableViewRowAnimationNone];
}

- (IBAction)btnSaveAction:(id)sender
{
    if ([strFullName isEqualToString:self.appDel.objModelUserInfo.strUserName] && [strEmail isEqualToString:self.appDel.objModelUserInfo.strUserEmail] && [strDob isEqualToString:self.appDel.objModelUserInfo.strUserDob] && [strCountry isEqualToString:self.appDel.objModelUserInfo.strUserCountry] && [strGender isEqualToString:self.appDel.objModelUserInfo.strUserSex] && ([self image:imgVwProfilePic.image isEqualTo:userImage]))
    {
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"" message:@"Profile Updated successfully" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOK=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:^{
                
            }];
        }];
        [alertController addAction:actionOK];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }
    else
    {
        if ([self alertChecking])
        {
            [self initializeAndStartActivityIndicator:self.view];
            
            NSDictionary *editProfileDict = @{@"ApiKey":API_KEY,USERID:self.appDel.objModelUserInfo.strUserId,@"name":strFullName,@"email":strEmail,@"dob":strDob,@"country":strCountryId,@"gender":strGender};
            
            NSLog(@"editProfileDict:%@",editProfileDict);
            
            [[EditProfileWebService service]callEditProfileWebServiceWithDictParams:editProfileDict profileImage:([self image:imgVwProfilePic.image isEqualTo:userImage])?nil:imgVwProfilePic.image success:^(id  _Nullable response, NSString * _Nullable strMsg){
                
                 [self StopActivityIndicator:self.view];
                
                if (response != nil)
                {
                    NSDictionary *loginDict = [NSDictionary dictionaryWithDictionary:response[@"ResponseData"]];
                    
                    self.appDel.objModelUserInfo = [[ModelUserInfo alloc]initWithDictionary:loginDict];
                    
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:loginDict];
                    
                    [GlobalUserDefaults saveObject:data withKey:USER_INFO];
                    
                    NSData *imgData = UIImageJPEGRepresentation(imgVwProfilePic.image, 0.4);
                    
                    [GlobalUserDefaults saveObject:imgData withKey:PROFILE_IMAGE];
                    
                    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"" message:@"Profile Updated Successfully" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *actionOK=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [alertController dismissViewControllerAnimated:YES completion:^{
                            
                        }];
                    }];
                    [alertController addAction:actionOK];
                    [self presentViewController:alertController animated:YES completion:^{
                        
                    }];
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
    
}

#pragma mark
#pragma mark For Taking Image From Camera & Gallery
#pragma mark

- (void)setImageFromCamera
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Select Option" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                              {
                                  //Do some thing here
                                  [self funImageFromGalary];
                              }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                              {
                                  //Do some thing here
                                  [self funImageFromPhoneCamera];
                                  
                              }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                              {
                                  //Do some thing here
                                  
                              }];
    
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark

- (void)funImageFromGalary
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage,nil];
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)funImageFromPhoneCamera
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        // show camera
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage,nil];
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else
    {
        // don't show camera
        [self displayErrorWithMessage:@"Please select from gallery"];
    }
}

#pragma mark

#pragma mark
#pragma mark Image Picker Delegate Method
#pragma mark

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    imgVwProfilePic.image = info[UIImagePickerControllerOriginalImage] ;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    });
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
        
    });
    
}

#pragma mark

#pragma mark
#pragma mark Alert Checking
#pragma mark

-(BOOL)alertChecking
{
    if (strEmail.length == 0 || [strEmail isEqualToString:@"Email"])
    {
        [self displayErrorWithMessage:@"Please enter your email address"];
        return NO;
    }
    if (![self isValidEmail:strEmail])
    {
        [self displayErrorWithMessage:@"Please enter a valid email id!"];
        return NO;
    }
    
    if (strDob.length == 0 || [strDob isEqualToString:@"Date Of Birth"])
    {
        [self displayErrorWithMessage:@"Please enter your date of birth"];
        return NO;
    }
    
    if (strCountry.length == 0 || [strCountry isEqualToString:@"Country"])
    {
        [self displayErrorWithMessage:@"Please select your country"];
        return NO;
    }
    
    return YES;
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
