//
//  MyProfileVC.m
//  Bangla 1st
//
//  Created by Abhijit Rana on 18/03/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "MyProfileVC.h"
#import "PackageListingVC.h"
#import "ProfileTableViewCell.h"

#define PROFILECELL @"profilePicCell"
#define PROFILEDETAILSCELL @"profileDetailsCell"
#define CURRENTCELL @"currentPlanCell"
#define RECOMENDCELL @"recomendedPlanCell"

#import "AccountDetailsWebService.h"
#import "PackageListingWebService.h"
#import "ModelPackageListing.h"
#import "ModelCouponData.h"


@interface MyProfileVC ()<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UIView *navbarContainerVw;
    
    IBOutlet UITableView *tblVwMyProfile;
    
    ModelPackageListing *objModelPackage;
    ModelCouponData *objModelCouponData;
    NSMutableArray *arrPackgeListing;
    BOOL isPackgListingWebServiceCalled;
    NSDateFormatter *dtFormatter;
}

@end

@implementation MyProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
   [self initWithParentView:navbarContainerVw isTranslateToAutoResizingMaskNeeded:NO leftButton:YES rightButton:YES navigationTitle:nil navigationTitleTextAlignment:NSTextAlignmentCenter navigationTitleFontType:nil leftImageName:@"menu_white_icon.png" leftLabelName:@"  Bangla1st" rightImageName:@"Search_white_icon.png" rightLabelName:nil];
    
    [self.navBar.navBarLeftButtonOutlet addTarget:self action:@selector(openmenu) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar.navBarRightButtonOutlet addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    tblVwMyProfile.dataSource = self;
    tblVwMyProfile.delegate = self;
    
    [self getAccountDetails];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    /*
    tblVwMyProfile = nil;
    tblVwMyProfile.dataSource = nil;
    tblVwMyProfile.delegate = nil;
     */
}

#pragma mark
#pragma mark - Get Account Details
#pragma mark

-(void)getAccountDetails
{
    [self initializeAndStartActivityIndicator:self.view];
    
    NSDictionary *MyAccountDict = @{@"ApiKey":@"0a2b8d7f9243305f2a4700e1870f673a",USERID:self.appDel.objModelUserInfo.strUserId};
    
    NSLog(@"MyAccountDict%@",MyAccountDict);
    
  [[AccountDetailsWebService service] callgetAccountDetailsWebServiceWithDictParams:MyAccountDict success:^(id  _Nullable response, NSString * _Nullable strMsg) {
      
      if (response != nil)
      {
          NSDictionary *loginDict = [NSDictionary dictionaryWithDictionary:response[@"ResponseData"]];
          
          self.appDel.objModelUserInfo = [[ModelUserInfo alloc]initWithDictionary:loginDict];
          
          NSData *data = [NSKeyedArchiver archivedDataWithRootObject:loginDict];
          
          [GlobalUserDefaults saveObject:data withKey:USER_INFO];
          
          [self getPackageListing];
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
 failure:^(NSError * _Nullable error, NSString * _Nullable strMsg) {
     
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
#pragma mark get package listing
#pragma mark

-(void)getPackageListing
{
    NSDictionary *packageListDict = @{@"ApiKey":@"0a2b8d7f9243305f2a4700e1870f673a",USERID:self.appDel.objModelUserInfo.strUserId};
    
    NSLog(@"packageListDict:%@",packageListDict);
    
    [[PackageListingWebService service]callPackageListingWebServiceWithDictParams:packageListDict success:^(id  _Nullable response, NSString * _Nullable strMsg) {
        
        [self StopActivityIndicator:self.view];
        
        if (response != nil)
        {
            isPackgListingWebServiceCalled = YES;
            
            if ([response[@"coupon_active"] isEqualToString:@"yes"])
            {
                objModelCouponData = [[ModelCouponData alloc]initWithDictionary:response[@"coupon_data"]];
                
                [tblVwMyProfile reloadData];
            }
            else
            {
                if ([response[@"ResponseData"] isKindOfClass:[NSArray class]])
                {
                    NSArray *arr = (id)response[@"ResponseData"];
                    
                    arrPackgeListing = [NSMutableArray new];
                    
                    for (int i = 0; i<arr.count; i++)
                    {
                        objModelPackage = [[ModelPackageListing alloc]initWithDictionary:arr[i]];
                        
                        [arrPackgeListing addObject:objModelPackage];
                    }
                    
                    [tblVwMyProfile reloadData];
                }
                else
                {
                    NSLog(@"Response is not an array");
                }
            
            }
            
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

#pragma mark
#pragma mark - Open Left Pannel
#pragma mark

-(void)openmenu
{
    [self.view endEditing:YES];
    [self openLeftPanel];
}

#pragma mark
#pragma mark - Search Button
#pragma mark

-(void)searchButtonAction
{
}

#pragma mark
#pragma mark - Edit Profile Button
#pragma mark

-(void)editprofileBtnTap:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"segueToEditProfile" sender:self];
}

#pragma mark
#pragma mark - Upgrade Button
#pragma mark

-(void)upgradeBtnTap:(UIButton *)sender
{
   PackageListingVC *packageVc=(PackageListingVC *)[MainStoryBoard instantiateViewControllerWithIdentifier:@"PackageListingVC"];
    packageVc.arrPkgListing = arrPackgeListing;
    
    [self.navigationController pushViewController:packageVc animated:YES];
}

#pragma mark
#pragma mark Tableview delegates and Datasource
#pragma mark


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 1;
    }
    else
        */
        return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 1)
    {
        return 0;
    }
    else
        return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *vwHeader;
    UILabel *lblHeader;

    if (section == 2)
    {
        vwHeader=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
        [vwHeader setBackgroundColor:[UIColor whiteColor]];
        vwHeader.tag = section;
        lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, vwHeader.frame.size.width-20, vwHeader.frame.size.height)];
        lblHeader.textColor = [UIColor darkGrayColor];
        lblHeader.font = [UIFont  systemFontOfSize:15.0 weight:UIFontWeightSemibold];
        
        lblHeader.text = @"Current Plan";
        
        [vwHeader addSubview:lblHeader];
        return vwHeader;
    }
    
    /*
    else if (section == 3)
    {
        vwHeader=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
        [vwHeader setBackgroundColor:[UIColor whiteColor]];
        vwHeader.tag = section;
        lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, vwHeader.frame.size.width-20, vwHeader.frame.size.height)];
        lblHeader.textColor = [UIColor darkGrayColor];
        lblHeader.font = [UIFont  systemFontOfSize:15.0 weight:UIFontWeightSemibold];
        
        lblHeader.text = @"Recomended Plan";
        
        [vwHeader addSubview:lblHeader];
        return vwHeader;
    }
     */
    else
        return 0;
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        if (IS_IPHONE_6_PLUS || IS_IPHONE_6)
        {
            return  140.0;
        }
        else
         return  125.0;
    }
    else if (indexPath.section == 1)
    {
        if (IS_IPHONE_6_PLUS || IS_IPHONE_6)
        {
            return  165.0;
        }
        else
         return  150.0;
    }
    /*
    else if (indexPath.section == 2)
    {
        if (IS_IPHONE_6_PLUS || IS_IPHONE_6)
        {
            return  90.0;
        }
        else
         return  80.0;
    }
     */
    else
    {
        if (IS_IPHONE_6_PLUS || IS_IPHONE_6)
        {
            return  270.0;
        }
        else
            return  240.0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *strIdentifier=@"ExperienceTableCell"; //lessonCell
    
    if (indexPath.section == 0)
    {
        ProfileTableViewCell *cell = (ProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:PROFILECELL];
        if (cell==nil)
        {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"ProfileTableViewCell" owner:self options:nil]objectAtIndex:0];
        }
        
        cell.imgVwProfilePic.image = [UIImage imageWithData:[GlobalUserDefaults getObjectWithKey:PROFILE_IMAGE]];
        
        //cell.lblName.text = self.appDel.objModelUserInfo.strUserName;  //[indexPath.row] objectForKey:@"level"];
        
        [cell.btnEditProfileOutlet addTarget:self action:@selector(editprofileBtnTap:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    else if (indexPath.section == 1)
    {
        ProfileTableViewCell *cell = (ProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:PROFILEDETAILSCELL];
        if (cell==nil)
        {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"ProfileTableViewCell" owner:self options:nil]objectAtIndex:1];
        }
        
        cell.lblProfileName.text =  ([self isEmpty:self.appDel.objModelUserInfo.strUserName])?@"":self.appDel.objModelUserInfo.strUserName;
        cell.lblProfileEmail.text = ([self isEmpty:self.appDel.objModelUserInfo.strUserEmail])?@"":self.appDel.objModelUserInfo.strUserEmail;
        cell.lblProfileGender.text = ([self isEmpty:self.appDel.objModelUserInfo.strUserSex])?@"":self.appDel.objModelUserInfo.strUserSex;
        cell.lblProfileDob.text = ([self isEmpty:self.appDel.objModelUserInfo.strUserDob])?@"":self.appDel.objModelUserInfo.strUserDob;
        cell.lblProfileCountry.text = ([self isEmpty:self.appDel.objModelUserInfo.strUserCountry])?@"":self.appDel.objModelUserInfo.strUserCountry;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    else       //if (indexPath.section == 2)
    {
        ProfileTableViewCell *cell = (ProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CURRENTCELL];
        if (cell==nil)
        {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"ProfileTableViewCell" owner:self options:nil]objectAtIndex:2];
        }
        
        [cell.btnUpgradeOutlet addTarget:self action:@selector(upgradeBtnTap:) forControlEvents:UIControlEventTouchUpInside];
        
        if (isPackgListingWebServiceCalled)
        {
            if (objModelCouponData !=nil)
            {
                cell.containerView.hidden = NO;
                cell.lblNoSubscription.hidden = YES;
                
                cell.lblPackagePrice.text = [NSString stringWithFormat:@"Rs. %@ /day",objModelCouponData.strCouponPackagePrice];
                cell.lblValidity.text = [NSString stringWithFormat:@"Valid for %@ day(s)",objModelCouponData.strCouponPackageDays];
                cell.lblVideoWatchLimit.text = [NSString stringWithFormat:@"Video Watch Limit %@",objModelCouponData.strCouponPackageVideoLimit];
                cell.lblTotalLimit.text = [NSString stringWithFormat:@"Total Limit %@",objModelCouponData.strCouponPackageTotalLimit];
                cell.lblPackageStatus.text = @"Activated";
                cell.lblPackageStatus.textColor = [UIColor colorWithRed:255.0/255.0 green:83.0/255.0 blue:31.0/255.0 alpha:1.0];
                
                dtFormatter = [[NSDateFormatter alloc]init];
                [dtFormatter setDateFormat:@"dd-mm-yyyy"];
                NSDate *subscriptionEndDate = [dtFormatter dateFromString:objModelCouponData.strCouponSubscriptionEndDate];
                NSString *strCurrentDate = [dtFormatter stringFromDate:[NSDate date]];
                NSDate *currentDt = [dtFormatter dateFromString:strCurrentDate];
                
                if ([subscriptionEndDate compare:currentDt] == NSOrderedDescending)
                {
                    NSLog(@"date1 is later than date2");
                    
                    cell.btnUpgradeOutlet.userInteractionEnabled = NO;
                    cell.btnUpgradeOutlet.layer.borderColor = [UIColor lightGrayColor].CGColor;
                    [cell.btnUpgradeOutlet setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                }
                else if ([subscriptionEndDate compare:currentDt] == NSOrderedAscending)
                {
                    NSLog(@"date1 is earlier than date2");
                    cell.btnUpgradeOutlet.userInteractionEnabled = YES;
                    cell.btnUpgradeOutlet.layer.borderColor = [UIColor colorWithRed:255.0/255.0 green:83.0/255.0 blue:31.0/255.0 alpha:1.0].CGColor;
                    [cell.btnUpgradeOutlet setTitleColor:[UIColor colorWithRed:255.0/255.0 green:83.0/255.0 blue:31.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                }
                else
                {
                    NSLog(@"dates are the same");
                    cell.btnUpgradeOutlet.userInteractionEnabled = YES;
                    cell.btnUpgradeOutlet.layer.borderColor = [UIColor colorWithRed:255.0/255.0 green:83.0/255.0 blue:31.0/255.0 alpha:1.0].CGColor;
                    [cell.btnUpgradeOutlet setTitleColor:[UIColor colorWithRed:255.0/255.0 green:83.0/255.0 blue:31.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                }
                
            }
            else
            {
                if (arrPackgeListing.count)
                {
                    cell.containerView.hidden = NO;
                    cell.lblNoSubscription.hidden = YES;
                    
                    for (int  i = 0; i<arrPackgeListing.count; i++)
                    {
                        if([[arrPackgeListing[i] strPackageIsSubscribed] isEqualToString:@"yes"])
                        {
                            isPackgListingWebServiceCalled = NO;
                            cell.lblPackageName.text = [arrPackgeListing[i] strPackageTitle];
                            cell.lblPackagePrice.text = [NSString stringWithFormat:@"Rs. %@ /day",[arrPackgeListing[i] strPackagePrice]];
                            cell.lblValidity.text = [NSString stringWithFormat:@"Valid for %@ day(s)",[arrPackgeListing[i] strPackageDays]];
                            cell.lblVideoWatchLimit.text = [NSString stringWithFormat:@"Video Watch Limit %@",[arrPackgeListing[i] strPackageVideoLimit]];
                            cell.lblTotalLimit.text = [NSString stringWithFormat:@"Total Limit %@",[arrPackgeListing[i] strPackageTotalLimit]];
                            cell.lblPackageStatus.text = @"Activated";
                            cell.lblPackageStatus.textColor = [UIColor colorWithRed:255.0/255.0 green:83.0/255.0 blue:31.0/255.0 alpha:1.0];
                        }
                        else if ([[arrPackgeListing[i] strPackageStatus] isEqualToString:@"yes"])
                        {
                            isPackgListingWebServiceCalled = NO;
                            cell.lblPackageName.text = [arrPackgeListing[i] strPackageTitle];
                            cell.lblPackagePrice.text = [NSString stringWithFormat:@"Rs. %@ /day",[arrPackgeListing[i] strPackagePrice]];
                            cell.lblValidity.text = [NSString stringWithFormat:@"Valid for %@ day(s)",[arrPackgeListing[i] strPackageDays]];
                            cell.lblVideoWatchLimit.text = [NSString stringWithFormat:@"Video Watch Limit %@",[arrPackgeListing[i] strPackageVideoLimit]];
                            cell.lblTotalLimit.text = [NSString stringWithFormat:@"Total Limit %@",[arrPackgeListing[i] strPackageTotalLimit]];
                            cell.lblPackageStatus.text = @"Activated";
                            cell.lblPackageStatus.textColor = [UIColor colorWithRed:255.0/255.0 green:83.0/255.0 blue:31.0/255.0 alpha:1.0];
                        }
                        else
                        {
                            
                        }
                       
                    }
                    
                }
                else
                {
                    cell.containerView.hidden = YES;
                    cell.lblNoSubscription.hidden = NO;
                }
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    
    /*
     else
     {
     ProfileTableViewCell *cell = (ProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:RECOMENDCELL];
     if (cell==nil)
     {
     cell=[[[NSBundle mainBundle]loadNibNamed:@"ProfileTableViewCell" owner:self options:nil]objectAtIndex:3];
     }
     
     NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
     [style setAlignment:NSTextAlignmentLeft];
     [style setLineBreakMode:NSLineBreakByWordWrapping];
     
     UIColor *colorGray = [UIColor darkGrayColor];
     // UIColor *colorRed = [UIColor colorWithRed:255.0/255.0 green:83.0/255.0 blue:31.0/255.0 alpha:1.0];
     
     UIFont *font1 = [UIFont systemFontOfSize:14.0];
     // UIFont *font2 = [UIFont systemFontOfSize:14.0];
     NSDictionary *dict1 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
     NSFontAttributeName:font1,
     NSForegroundColorAttributeName : colorGray,
     NSParagraphStyleAttributeName:style};
     //        NSDictionary *dict2 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
     //                                NSFontAttributeName:font1,
     //                                NSForegroundColorAttributeName : colorRed,
     //                                NSParagraphStyleAttributeName:style};
     
     
     NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
     [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"To Download unlimited HD video and listen Music with premium membership." attributes:dict1]];
     // [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Premium Plus \n\n" attributes:dict2]];
     // [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Just for Rs.120/month" attributes:dict1]];
     
     cell.txtVwRecomendedContent.attributedText = attString;
     
     [cell.txtVwRecomendedContent setContentOffset:CGPointMake(0,-150) animated:NO];
     
     [cell.btnUpgradeOutlet addTarget:self action:@selector(upgradeBtnTap:) forControlEvents:UIControlEventTouchUpInside];
     
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     
     return cell;
     }
     */
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
