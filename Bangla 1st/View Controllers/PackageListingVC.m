//
//  PackageListingVC.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 01/05/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "PackageListingVC.h"
#import "PackageListCollectionViewCell.h"
#import "PackageListingWebService.h"
#import "CouponCodePostWebService.h"
#import "ModelPackageListing.h"
#import "ModelCouponData.h"
#import "MemberSubscriptionWebService.h"

@interface PackageListingVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
{
    IBOutlet UIView *navBarContainerView;
    
    IBOutlet UICollectionView *collectionViewPackage;
    
    IBOutlet UIView *viewPromoCodeContainer;
    
    IBOutlet UITextField *txtPromoCode;
    
    IBOutlet UILabel *lblNoPackageList;
    
    
    BOOL isViewUp;
    NSString *strPromoCode;
    
   
    ModelPackageListing *objModelPackage;
    ModelCouponData *objModelCouponData;
    
}

@end

@implementation PackageListingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIFont *customFont = [UIFont fontWithName:@"BerlinSansFB-Reg" size:20];
    
    [self initWithParentView:navBarContainerView isTranslateToAutoResizingMaskNeeded:NO leftButton:YES rightButton:NO navigationTitle:@"Package Listing" navigationTitleTextAlignment:NSTextAlignmentCenter navigationTitleFontType:customFont leftImageName:@"back_arrow.png" leftLabelName:@" Back" rightImageName:nil rightLabelName:nil];
    
    [self.navBar.navBarLeftButtonOutlet addTarget:self action:@selector(backBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    
    txtPromoCode.layer.borderColor = [UIColor grayColor].CGColor;
    txtPromoCode.layer.borderWidth = 1.0;
    txtPromoCode.layer.cornerRadius = 2.0;
    txtPromoCode.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    
    [viewPromoCodeContainer.layer setCornerRadius:2.0f];
    
    // border
    [viewPromoCodeContainer.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [viewPromoCodeContainer.layer setBorderWidth:0.5f];
    
    // drop shadow
    [viewPromoCodeContainer.layer setShadowColor:[UIColor blackColor].CGColor];
    [viewPromoCodeContainer.layer setShadowOpacity:0.4];
    [viewPromoCodeContainer.layer setShadowRadius:1.0];
    [viewPromoCodeContainer.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
    
  //  [self initializeAndStartActivityIndicator:self.view];
   // [self getPackageListing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
           if ([response[@"coupon_active"] isEqualToString:@"yes"])
           {
               objModelCouponData = [[ModelCouponData alloc]initWithDictionary:response[@"coupon_data"]];
           }
           
           if ([response[@"ResponseData"] isKindOfClass:[NSArray class]])
           {
               NSArray *arr = (id)response[@"ResponseData"];
               
               _arrPkgListing = [NSMutableArray new];
               
               for (int i = 0; i<arr.count; i++)
               {
                   objModelPackage = [[ModelPackageListing alloc]initWithDictionary:arr[i]];
                   
                   [_arrPkgListing addObject:objModelPackage];
               }
           }
           else
           {
               NSLog(@"Response is not an array");
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
       
       if (_arrPkgListing.count)
       {
           lblNoPackageList.hidden = YES;
           collectionViewPackage.hidden = NO;
           [collectionViewPackage reloadData];
       }
       else
       {
           lblNoPackageList.hidden = NO;
           collectionViewPackage.hidden = YES;
       }
       
   } failure:^(NSError * _Nullable error, NSString * _Nullable strMsg) {
       
       [self StopActivityIndicator:self.view];
       
       lblNoPackageList.hidden = NO;
       collectionViewPackage.hidden = YES;
       
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
#pragma mark Collection view layout things
#pragma mark

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   /*
    CGFloat width,height;
    width = 170;  //-340/8.6;
    height =170;  //-340/8.6;
    return CGSizeMake(width,height);
    */
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth / 2.0; //Replace the divisor with the column count requirement. Make sure to have it in float.
    CGSize size = CGSizeMake(cellWidth, cellWidth);
    
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.1;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}

#pragma mark
#pragma mark collection view delegate
#pragma mark
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return _arrPkgListing.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *identifier = @"packageCell";
    
    [collectionView registerClass:[PackageListCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    //here we load xib. to our collection view
    [collectionView registerNib:[UINib nibWithNibName:@"PackageListCollectionViewCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:identifier];
    
    PackageListCollectionViewCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.lblPackageName.text = [_arrPkgListing[indexPath.row] strPackageTitle];
    cell.lblPackagePrice.text = [NSString stringWithFormat:@"Rs. %@ /day",[_arrPkgListing[indexPath.row] strPackagePrice]];
    cell.lblValidity.text = [NSString stringWithFormat:@"Valid for %@ day(s)",[_arrPkgListing[indexPath.row] strPackageDays]];
    cell.lblVideoWatchLimit.text = [NSString stringWithFormat:@"Video Watch Limit %@",[_arrPkgListing[indexPath.row] strPackageVideoLimit]];
    cell.lblTotalLimit.text = [NSString stringWithFormat:@"Total Limit %@",[_arrPkgListing[indexPath.row] strPackageTotalLimit]];
    
    if([[_arrPkgListing[indexPath.row] strPackageIsSubscribed] isEqualToString:@"no"])
    {
        cell.lblPackageStatus.text = @"De-Activated";
        cell.lblPackageStatus.textColor = [UIColor darkGrayColor];
    }
    else
    {
        cell.lblPackageStatus.text = @"Activated";
        cell.lblPackageStatus.textColor = [UIColor colorWithRed:255.0/255.0 green:83.0/255.0 blue:31.0/255.0 alpha:1.0];
    }
    
    return  cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *memberSubscrptDict = @{@"ApiKey":@"0a2b8d7f9243305f2a4700e1870f673a",USERID:self.appDel.objModelUserInfo.strUserId,@"packageID":[_arrPkgListing[indexPath.row]strPackageID]};
    
    [self callMemberSubscriptionWebServiceWithDict:memberSubscrptDict];
}

#pragma mark
#pragma mark - textfield delegate
#pragma mark

- (IBAction)txtPromoCodeEditChanged:(id)sender
{
    UITextField *textField=(id)sender;
     strPromoCode=[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (isViewUp) {
        
    }
    else
        [self viewUp];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
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
            self.view.frame=CGRectMake(self.view.frame.origin.x,-185, self.view.frame.size.width, self.view.frame.size.height);
            isViewUp=YES;
        }];
    }
    else
        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame=CGRectMake(self.view.frame.origin.x,-155, self.view.frame.size.width, self.view.frame.size.height);
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
#pragma mark Member Subscription web service
#pragma mark

-(void)callMemberSubscriptionWebServiceWithDict:(NSDictionary *)dict
{
    [self initializeAndStartActivityIndicator:self.view];
    
    NSLog(@"MemberSubscriptionDict:%@",dict);
    
    [[MemberSubscriptionWebService service]callMemberSubscriptionWebServiceWithDictParams:dict success:^(id  _Nullable response, NSString * _Nullable strMsg) {
        
        [self StopActivityIndicator:self.view];
        
        if (response != nil)
        {
            UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"" message:response[@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOK=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alertController dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }];
            [alertController addAction:actionOK];
            [self presentViewController:alertController animated:YES completion:^{
                
            }];
            
            if ([response[@"ResponseData"] isKindOfClass:[NSArray class]])
            {
                NSArray *arr = (id)response[@"ResponseData"];
                
                _arrPkgListing = [NSMutableArray new];
                
                for (int i = 0; i<arr.count; i++)
                {
                    objModelPackage = [[ModelPackageListing alloc]initWithDictionary:arr[i]];
                    
                    [_arrPkgListing addObject:objModelPackage];
                }
                
                [collectionViewPackage reloadData];
            }
            else
            {
                NSLog(@"Response is not an array");
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
#pragma mark Button Action
#pragma mark

-(void)backBtnTap:(UIButton *)sender
{
    collectionViewPackage = nil;
    collectionViewPackage.dataSource = nil;
    collectionViewPackage.delegate = nil;
    
    if (isViewUp)
    {
        [self viewDown];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnActivateAction:(id)sender
{
    if ([self alertChecking])
    {
        [self initializeAndStartActivityIndicator:self.view];
        
        NSDictionary *couponDict = @{@"ApiKey":@"0a2b8d7f9243305f2a4700e1870f673a",@"userid":self.appDel.objModelUserInfo.strUserId,@"couponCode":strPromoCode};
        
        [[CouponCodePostWebService service] callCouponCodePostWithDictParams:couponDict success:^(id  _Nullable response, NSString * _Nullable strMsg)
         {
             [self StopActivityIndicator:self.view];
             
             if (response != nil)
             {
                 
                 if ([response[@"message"] isEqualToString:@"User Subscribed Successfully"])
                 {
                     UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"" message:@"User Subscribed Successfully" preferredStyle:UIAlertControllerStyleAlert];
                     UIAlertAction *actionOK=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                         [alertController dismissViewControllerAnimated:YES completion:^{
                             
                         }];
                         
                         [self.navigationController popViewControllerAnimated:YES];
                     }];
                     [alertController addAction:actionOK];
                     [self presentViewController:alertController animated:YES completion:^{
                         
                     }];
                 }
                 else
                 {
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
    
}


#pragma mark
#pragma mark Alert Checking
#pragma mark

-(BOOL)alertChecking
{
    if (strPromoCode.length==0)
    {
        [self displayErrorWithMessage:@"Please enter valid Promo Code"];
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
