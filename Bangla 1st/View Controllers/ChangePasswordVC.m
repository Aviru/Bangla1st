//
//  ChangePasswordVC.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 30/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "ChangePasswordVC.h"
#import "EditProfileTableViewCell.h"
#import "CMPopTipView.h"
#import "ChangePasswordWebService.h"

@interface ChangePasswordVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,CMPopTipViewDelegate>
{
    IBOutlet UITableView *tblChangePassword;
    IBOutlet UIView *containerView;
    
    UITextField *globalTextField;
    
    BOOL isPasswordShown, isValidPassword;
    NSString *strNewRePassword, *strNewPassword, *strOldPassword;
    NSMutableArray *arrPlaceHolder;
    
}

@end

@implementation ChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrPlaceHolder = [[NSMutableArray alloc]initWithObjects:@"Old Password",@"New Password",@"Re-enter New Password", nil];
    
    [containerView.layer setCornerRadius:2.0f];
    
    // border
    [containerView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [containerView.layer setBorderWidth:0.5f];
    
    // drop shadow
    [containerView.layer setShadowColor:[UIColor blackColor].CGColor];
    [containerView.layer setShadowOpacity:0.4];
    [containerView.layer setShadowRadius:1.0];
    [containerView.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
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
    return 3.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditProfileTableViewCell *cell = (EditProfileTableViewCell *)[tblChangePassword dequeueReusableCellWithIdentifier:@"editPasswordCell"];
    if (cell==nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"EditProfileTableViewCell" owner:self options:nil]objectAtIndex:2];
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
    
    cell.txtEditPassword.attributedPlaceholder = attString;
    
    cell.txtEditPassword.delegate = self;
    [cell.txtEditPassword addTarget:self
                             action:@selector(textFieldDidChange:)
                   forControlEvents:UIControlEventEditingChanged];

    cell.txtEditPassword.tag = indexPath.row;
    
    cell.imgVwTextFieldBorder.layer.borderColor = [UIColor grayColor].CGColor;
    cell.imgVwTextFieldBorder.layer.borderWidth = 1.0;
    cell.imgVwTextFieldBorder.layer.cornerRadius = 2.0;
    cell.txtEditPassword.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    cell.txtEditPassword.secureTextEntry = YES;
   
    [cell.btnShowPasswordOutlet addTarget:self action:@selector(btnHideUnhidePaswdTap:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark
#pragma mark - textfield delegate
#pragma mark

-(void)textFieldDidChange:(UITextField *)theTextField
{
    if (theTextField.tag==0)
    {
        strOldPassword=[theTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (strOldPassword.length > 0)
        {
            [arrPlaceHolder removeObjectAtIndex:theTextField.tag];
            [arrPlaceHolder insertObject:strOldPassword atIndex:theTextField.tag];
        }
        else
        {
            [arrPlaceHolder removeObjectAtIndex:theTextField.tag];
            [arrPlaceHolder insertObject:@"Old Password" atIndex:theTextField.tag];
        }
    }
    
    else if (theTextField.tag==1)
    {
        strNewPassword=[theTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (strNewPassword.length > 0)
        {
            [self isContainUpperCase:strNewPassword];
            [self isContainLowerCase:strNewPassword];
            [self isContainSpecialCase:strNewPassword];
            [self isContainDigit:strNewPassword];
            [self isLengthMoreThan6:strNewPassword];
            
            if([self isContainUpperCase:strNewPassword] &&  [self isContainLowerCase:strNewPassword] &&    [self isContainSpecialCase:strNewPassword] &&    [self isContainDigit:strNewPassword] &&    [self isLengthMoreThan6:strNewPassword])
            {
                isValidPassword = YES;
            }
            else
            {
                isValidPassword = NO;
            }
            
            [arrPlaceHolder removeObjectAtIndex:theTextField.tag];
            [arrPlaceHolder insertObject:strNewPassword atIndex:theTextField.tag];
        }
        else
        {
            [arrPlaceHolder removeObjectAtIndex:theTextField.tag];
            [arrPlaceHolder insertObject:@"New Password" atIndex:theTextField.tag];
        }
    }
    else if (theTextField.tag==2)
    {
        strNewRePassword=[theTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (strNewRePassword.length > 0)
        {
            [arrPlaceHolder removeObjectAtIndex:theTextField.tag];
            [arrPlaceHolder insertObject:strNewRePassword atIndex:theTextField.tag];
        }
        else
        {
            [arrPlaceHolder removeObjectAtIndex:theTextField.tag];
            [arrPlaceHolder insertObject:@"Re-enter New Password" atIndex:theTextField.tag];
        }
    }
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark
#pragma mark CMPopTipView Delegate
#pragma mark


- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView
{
    
}


#pragma mark
#pragma mark Button Action
#pragma mark

-(void)btnHideUnhidePaswdTap:(UIButton *)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblChangePassword];
    NSIndexPath *indexPath = [tblChangePassword indexPathForRowAtPoint:buttonPosition];
    EditProfileTableViewCell *cell = (EditProfileTableViewCell *)[tblChangePassword cellForRowAtIndexPath:indexPath];
    
    if (isPasswordShown == NO)
    {
        isPasswordShown = YES;
        cell.imgVwEyeIcon.image = [UIImage imageNamed:@"password_hide_eye_icon.png"];
        [cell.txtEditPassword setSecureTextEntry:NO];
    }
    else
    {
        isPasswordShown = NO;
        cell.imgVwEyeIcon.image = [UIImage imageNamed:@"eye_gray.png"];
        [cell.txtEditPassword setSecureTextEntry:YES];
    }
}

- (IBAction)btnCancelAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)btnSubmitAction:(id)sender
{
    if ([self alertChecking])
    {
        [self initializeAndStartActivityIndicator:self.view];
        
       NSDictionary *changePasswdDict = @{@"ApiKey":@"0a2b8d7f9243305f2a4700e1870f673a",USERID:self.appDel.objModelUserInfo.strUserId,@"oldPassword":strOldPassword,@"newPassword":strNewRePassword};
        
        [[ChangePasswordWebService service]callChangePasswordWebServiceWithDictParams:changePasswdDict success:^(id  _Nullable response, NSString * _Nullable strMsg) {
            
            [self StopActivityIndicator:self.view];
            
            if (response != nil)
            {
                UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"" message:response[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionOK=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [alertController dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                    
                   // [self callLogOut];
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
}


#pragma mark
#pragma mark Alert Checking
#pragma mark

-(BOOL)alertChecking
{
    if (strOldPassword.length == 0)
    {
        [self displayErrorWithMessage:@"Please enter Old password"];
        return NO;
    }
    
    if (strNewPassword.length == 0)
    {
        [self displayErrorWithMessage:@"Please enter New password"];
        return NO;
    }

    
    if (isValidPassword == NO)
    {
        [self displayErrorWithMessage:@"Please enter Valid password"];
        return NO;
    }
    
    if (strNewRePassword.length == 0)
    {
        [self displayErrorWithMessage:@"Please re-enter New password"];
        return NO;
    }
    
    if (![strNewRePassword isEqualToString:strNewPassword])
    {
        [self displayErrorWithMessage:@"Re-enter Password mismatch"];
        return NO;
    }
    
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
